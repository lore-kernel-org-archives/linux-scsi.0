Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEAA32949E0;
	Sat,  5 Sep 2026 03:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788579148; cv=none; b=VnU5HyE54eobPebeUijPqhrNSH4Dc8R3zZGrDK8VDykoMD2revNNsoIXuaMz94FmBgh27XUSCY/Zi9l9UfyoV0GH0khqTc3Fvemp6Q4X8JvIJ4Y+5+u1b5eVlZk1z/pkuwm3GMV139F1J4zUrUp+8NMAPF52fsWOCp/1PjTE7hA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788579148; c=relaxed/simple;
	bh=wh6QhAAKHd7IaiR99UNg8wGhXFuxrUHHf5aFAA7BZ5w=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=liwhf2eqYGDJCOPKcEZrPIm4hQ+2GxWjrLfZf7gocgds03ifs2m/Fn/OLQUSEREZmtp6MeEDddxTMr3QxueDiT2KPKkLIsKUWm+TBIkT6fM0BDX/JNJqFxeAZkbUExzw/J9NNfhZF9WVrOyOJ3q6xvq3h9TEHKDaawCbcH9Ecws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F5U3m5CP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F5U3m5CP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C23341F00A3D;
	Sat,  5 Sep 2026 03:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788579147;
	bh=wh6QhAAKHd7IaiR99UNg8wGhXFuxrUHHf5aFAA7BZ5w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=F5U3m5CPrELwwVNtk+A7Mg0WO2cnx003eQGReY7S3fYgnDVDBAxmZ/o0FRpbihlyP
	 q7GFnH3ELJmABmau6isOpzPqRzazvr0GIgpGMJ8cS1NakGqBXhy71Av4fC8Jmnk4bz
	 XsPRH/MGBrpmcVSaKNbnXW8ELvDDy+fIQjVqLqAAin28k5FMM+KW7CLup/uCSRP901
	 k3HODgqNlJGbJKZxcDq0A4Y8rJ9Jj/E7gKjg2upbqYMXW4JoW1CH7Loo08HVjuqWT9
	 ircsyoNdWL/VzCfEhTXvpzhGGB8P3j7d6hVWyM+2HEYlq9mE5rXwcnd8B6q4npGlf+
	 g/OMSTmZlUfdQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 06/40] scsi: use struct scsi_sense_hdr to log sense
 keys and codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: "Heiko Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, cassel@kernel.org, linux-s390@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, linux-scsi@vger.kernel.org, dlemoal@kernel.org, linux-ide@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20260905032224.509860-7-dlemoal@kernel.org>
References: <20260905032224.509860-1-dlemoal@kernel.org>
 <20260905032224.509860-7-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 05 Sep 2026 03:32:26 +0000
Message-Id: <20260905033226.C23341F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Instead of passing the sense key, additional sense code and additional
> sense code qualifier as separate parameters, change the functions
> scsi_extd_sense_format(), scsi_format_extd_sense(), and
> usb_stor_show_sense() to take a pointer to a struct scsi_sense_hdr to
> access the sense key and sense code with a single argument.
>=20
> No functional change intended.
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260905032224.5098=
60-1-dlemoal@kernel.org?part=3D6

