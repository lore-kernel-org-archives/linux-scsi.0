Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D9A73290A5;
	Tue,  8 Sep 2026 10:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788863813; cv=none; b=NwG1Ze5Tz/CvdUVzxciw7+RVsrEY47KVHSv+PWknHGhXUPjxMPTLZ6gLRHVcgkwKXQ4Fbne0Ny4c0Kbjjq2zMj6XXZ2OIzUCjycp4ZwEdF3qO/nq0o9YF+0r9JpEDMyJBUcaCubpRh4XwO8L2uvS3xw0KTNFC/3wxlapjk8/ftk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788863813; c=relaxed/simple;
	bh=CmAlehuN2ZZt4+bsRWtVcEMe/F4NIu3gGKw0xNTnxtc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=I2tOlcmLicpNYlTfBGF3dBDX0B6mhSbnFCvDtyBwG3I666KDOLfsTB5o1vaypNJj+wiM4pQJgiVbptSt3wa/3srMSXUzelqyKqkyA/Q9Ko0XDROQlorrCq7HoosukOt9kLb65KnQK10fBv8v4CYS1fiPqe4/9D+g+YXT1sJrBZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f022RY6l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f022RY6l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A8EE1F00A3A;
	Tue,  8 Sep 2026 10:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788863811;
	bh=CmAlehuN2ZZt4+bsRWtVcEMe/F4NIu3gGKw0xNTnxtc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=f022RY6lbIUE8vwyO3w0LRnDsMi6S20NUd/4Viq9OfKK7DfXStGQIo/xGmyGptBIX
	 dtxkVajVWFL+EswKBgRh3u86QFkQwHCjbV/Dgqo6113NZLu2ZZNNwuESUFyr/Fh79I
	 8YXOCGynSOU5W7jbE1OVNy1EfHKtoFv5Fs23eaBInjnNu+lTuWVN/OCy7T0JwCYmXs
	 wGWSz2MLpkiiEWW9B3LT6NhKGpj+JuQtfZigkc/CeFzXCdgNE6+bfts/eCeHZFDGHv
	 PkUWJkH+e13Fl6sRA1nF7wZTUK16fCUNFMXRLyj3vhyinnK+zgNGtepbxkMZ4Gn8GS
	 oI3GYu7sgAVLw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 39/40] scsi: cleanup scsi_proto.h
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-s390@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, cassel@kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, dlemoal@kernel.org
In-Reply-To: <20260908090308.1085097-40-dlemoal@kernel.org>
References: <20260908090308.1085097-1-dlemoal@kernel.org>
 <20260908090308.1085097-40-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 08 Sep 2026 10:36:50 +0000
Message-Id: <20260908103651.6A8EE1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Now that all users of SCSI sense codes have been modified to use macro
> definitions and the 16-bits sense code instead of separate 8-bits ASC and
> ASCQ, remove the now unused asc and ascq fields of struct scsi_failure and
> struct scsi_sense_hdr, and the old (and incomplete) definitions of SCSI
> additional sense codes and sense code qualifiers in scsi_proto.h.
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908090308.1085=
097-1-dlemoal@kernel.org?part=3D39

