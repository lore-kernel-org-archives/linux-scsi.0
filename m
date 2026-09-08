Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB8754FB9AA;
	Tue,  8 Sep 2026 09:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788860589; cv=none; b=HuwG/vDKHwmVtX3gVJe6rwJ5xdV/HZMtROXIsqWPCzRFJDEMeHBQAiG6PGy16i2kfWcgunIWpkdscVyNr6dSt/EvtXt+hbdy+24OE/Ejc4qZyxRS/iV+7L5QeIDDc8XbBBSG9b+NrDm3wbl/6laaWHEISNxttgOSrmw0UtesobE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788860589; c=relaxed/simple;
	bh=1T7uNs0uUmlUQbs9z9huZEYY5nq8wR5GPHuWRUUQLkY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=nwYNKUg2vr8t96rPos/s+79zDb7B3mUsFsp5Xl2B6iUDXxFq3dgn8zAbmjpGbCTuXZJ1MMsU3S2bIcJDRldk3yWqBzdLFjMh1yg2j5z6jVajsqD4fwlBfS65t2x1/xL3srKWmfmspb571GKGbLqvU+vKaGw+Tk3GRf7fo1Ww3IY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ckmYkqqC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ckmYkqqC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B25151F00A3A;
	Tue,  8 Sep 2026 09:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788860588;
	bh=1T7uNs0uUmlUQbs9z9huZEYY5nq8wR5GPHuWRUUQLkY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ckmYkqqCN/O4AoPf9IkNZo2WhrmUUIUfpJUPJDbMA9Kroh+bmC4lozxDXd3EcYZfe
	 D5wYhWoHyOJ1Rx4DesRCFPVJnnMWdGCQQgJLmuHmu50JPgF+l4hOesb3y1g9cLDdXL
	 hSKgHPgApn7XFf8XtKJo/StEGe64dZzWvNcqPK4PrHTWDwmuimmcj3K4PqfjfEKnvD
	 S0DFtV4QL+e/9Jj2o+PXk1BX+Txg8eD1aiH+pnNwGxu12Lhqmp0Gan2dQHm+M8wa1g
	 SH/WCSKrqJeYy0jY7lDd9BD3E9LTvLMQu98dhSy/+FaE31nJHxw6xVTsRTMH+ASmwi
	 tR9K89u6g8HWw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 16/40] scsi: device_handlers: alua: use 16-bits
 defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: cassel@kernel.org, "Christian Borntraeger" <borntraeger@linux.ibm.com>, linux-scsi@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, linux-s390@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, dlemoal@kernel.org, "Vasily Gorbik" <gor@linux.ibm.com>, linux-ide@vger.kernel.org
In-Reply-To: <20260908090308.1085097-17-dlemoal@kernel.org>
References: <20260908090308.1085097-1-dlemoal@kernel.org>
 <20260908090308.1085097-17-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 08 Sep 2026 09:43:04 +0000
Message-Id: <20260908094307.B25151F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Refactor the SCSI ALUA devie handler driver to use the 16-bits sense_code
> field of struct scsi_sense_hdr and replace all hard-coded additional sense
> codes and additional sense code qualifiers with the enum values defined in
> include/scsi/scsi_sense.h. This helps with code clarity as the sense codes
> being processed are easier to test and self-documented.
>=20
> No functional change intended.
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908090308.1085=
097-1-dlemoal@kernel.org?part=3D16

