Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792811486;
	b=oh2MxfWRZTPC+K2fTkQAmlAVL/gbo5xbktWMvUX/saqum455Z+t38QmqTWeCqD+1q7ZO
	 teQlyBHPZFFYjlaqnnXsxDGLiN9BlAgn0oJ9NxOaITU1B+OUFiwMv/8RciZKvJ8Un9wtV
	 jEE/bKdCDnO+tl+6/iHcWDpl8jy32ARgFxCP8xs//GIoFLOzH8ciD2jsKauEznXNGDXKK
	 j6yE6Vot1PhbJwIcS0/cNmSRoZTg3ndui2pSct+0u3Isv5FJbGWjZ493VPeO9rlfLyg3K
	 IQEMo24Ndp5QORU0M/md3kkuX8J0+/ESyh2lauA8TovGjpkKqHITbL+Utqe8VSHfMuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792811486;
	h=Received:DKIM-Signature:To:Cc:Subject:From:In-Reply-To:Message-ID:
	 References:Date:MIME-Version:Content-Type;
	bh=f+dzbcqBNIap0fRw/fCUp+JHmn0LFoofL/Vx1WIBSeo=;
	b=pqe/JEbvGdY8SZyst7978DJC1/slDHL300k6bhaUXDiJR89R1zG52Nz8EOs+Qy8kxqCN
	 9NTkBNLcXHMZr6OX+onThnrAWcL1ZYBA+4+zBEFka5RaQl1bJ9FYqlDMPPrvQjzYoWAEe
	 ZAqVBfPob64Jb8w6z7J3N7E9bRfLl09GDThTrLN0Q13zIyeg31eT4fhlW8pkpU+TuZ/Fl
	 wT51AY9CY19KkYz3Nfq26X70A8Ckq1NrmpetWGheW7GVfjvGrefCjmBwh5HU4Pl44rolZ
	 ut68C1zAxN6sZoguHV7TRz+LR9BlSEqSYiWwWWG3EapRLtgQP/jngMoSM2bDLgj2STg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fi2d7pIS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDDB9606A31B;
	Sat, 24 Oct 2026 03:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fi2d7pIS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08C0E1F01825;
	Sat, 24 Oct 2026 03:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792811485;
	bh=f+dzbcqBNIap0fRw/fCUp+JHmn0LFoofL/Vx1WIBSeo=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=fi2d7pIS3VLA+R1oEil0HcZ7uV+C04si11yb5+PyKeaK8zE3rFGwtsLJS8TnsSot3
	 RIJ5b9sWYRjxNMHNqPT7C32zQDLplx9BDHk2hy2jJRIfl2da6s1m43KjYYyQLoh99l
	 Wqk7ur4UN+Fx0wChsL19k/8Jo7ltPQXeBLrVeZjSBx5PX6gyw3qUC3amEfjZjpruiu
	 Tnti619vYGQtMD/mntnoZdWdXFRTh4o53MTp144ZVHUWeIkhqNcGTe8Y0MMpGCGbHl
	 bFlW5xfoUN27tNAF/T2pM2mHoQ84Egnz3Ry18T4aDhSdMiOAcFnWsTHxGStCeD/I55
	 3w5jhEWKFemtg==
To: Karan Tilak Kumar <kartilak@cisco.com>
Cc: sebaddel@cisco.com,  arulponn@cisco.com,  djhawar@cisco.com,
  gcboffa@cisco.com,  mkai2@cisco.com,  satishkh@cisco.com,
  aeasi@cisco.com,  jejb@linux.ibm.com,  martin.petersen@oracle.com,
  linux-scsi@vger.kernel.org,  linux-kernel@vger.kernel.org,
  jmeneghi@redhat.com,  revers@redhat.com,  adakopou@redhat.com,
  lduncan@suse.com
Subject: Re: [PATCH] scsi: fnic: Update module authors
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <20261020210043.5279-1-kartilak@cisco.com>
Message-ID: <yq1h5ib7pyj.fsf@mail.kernel.org>
References: <20261020210043.5279-1-kartilak@cisco.com>
Date: Fri, 23 Oct 2026 23:11:24 -0400
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain


Karan,

> Update the FNIC module author list and bump the driver version to
> 1.9.0.2.

Applied to 7.4/scsi-staging, thanks!

-- 
Martin K. Petersen
