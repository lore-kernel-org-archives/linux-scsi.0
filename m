Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=165.173.182.55
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792564727;
	b=0m8Lql45J8ZNDVaAQ+IgWkESYzs6lgfYP2SADOmk1iQwasvOHN7vq7Mut54HzCgJPGfA
	 IW+dtCBdTTaGM7N2ZPqyFRVgoELlylAfyP26Su8jydkuTQuQMwrKMuZgWz+5bc7yhis7I
	 l2deD0CvQAltAZzK5BbSzaSse16Ofkfhn7ifzWtOD3eemEuBTXEIoHPMql3ZYihlS8zmY
	 FmBZwOic11AxFw5fWFqElUycOIX+icFy6hF9VVXQdi1fRVClQbYWHtoEOHzjldxXT+dST
	 DfxBaI6VTI1GyVFqf3jkrbpMUdafVh2lmeuAG4CiTf5qbYQ92eB0D+NQBVp1YNJ992w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792564727;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:In-Reply-To:References:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=BDt6l5GDnoTOng5Fb3euqR8Bsj7Oowlxk5tDbRhdWIY=;
	b=Lh14kuF1kZQYxxGoHA9erAb1tp5M5g3rfZ8UvKjmHWZsqD7I/BoCd/u2hl3CQilUMGJ1
	 xGAWYZw6K0lBjSx203ptt2z+CVzKkGGouKcBnPmr/g6mf5EDrn1WvpfSHmFN4+A4lQoRJ
	 LuRaDQIrMY7qHlVgUMNcQazH8j2pqRDYxweOxT4+gifXQd4vptSG4fFIeB2NaN9wyVirN
	 FvbFqsyWvORxz7sazWegQyvsPJIV6tZB9eYmV9+sF/MCLxJoKWQTPZ1bedT5VFeXmQ240
	 vZkglz8r2ItrmOu+LLI9g1jLypW0Cw9MTgAFxZOfuN1FCO//K78l3wy5rA3NGoVKnfA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=palmit.com.au;
	spf=pass smtp.mailfrom=palmit.com.au;
	dkim=pass header.d=palmit.com.au header.i=vince@palmit.com.au header.a=rsa-sha256 header.s=zmail header.b=wAc2rPgN;
	arc=pass header.oldest-pass=0 smtp.remote-ip=165.173.182.55
Received: from sender5-of-o55.zoho.com (sender5-of-o55.zoho.com [165.173.182.55])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDCC8606A320;
	Wed, 21 Oct 2026 06:38:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DDCC8606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=palmit.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=palmit.com.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=palmit.com.au header.i=vince@palmit.com.au header.a=rsa-sha256 header.s=zmail header.b=wAc2rPgN
ARC-Seal: i=1; a=rsa-sha256; t=1792564719; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=ixAuT6BZchITl4maYtsEjqj6z2ODZLzzQJ3Y8o/Yv2qrdwk0897RoS4T//ji6nZuwFyGbCe6o9O5ctCQfgYZj/XspyJ+DfptNhqieZjg/xd2HSD6cfeBgqLXrEZJYBh4JBcFXHnzNOMbCQO7qkr5povAciR6JQjk02ljR2iz6oM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1792564719; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=BDt6l5GDnoTOng5Fb3euqR8Bsj7Oowlxk5tDbRhdWIY=; 
	b=NKD52nisB1U3l9TEOSgYgswunxsvCnY/7brm9VG8Azxd9+hI82UJ2Fu8VtDtmhdkfpd5opnQP5DJIq4nxxpqKsQvX3LWEImLslxLS8jK2mhQXSqI0CWVs2diqIvq3NLjPsN9pq3+7G3ZLJNjrQj1GWV3+QycVp6XJghRnDCeyQs=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=palmit.com.au;
	spf=pass  smtp.mailfrom=vince@palmit.com.au;
	dmarc=pass header.from=<vince@palmit.com.au>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1792564719;
	s=zmail; d=palmit.com.au; i=vince@palmit.com.au;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:Content-Type:Content-Transfer-Encoding:MIME-Version:Message-Id:Reply-To;
	bh=BDt6l5GDnoTOng5Fb3euqR8Bsj7Oowlxk5tDbRhdWIY=;
	b=wAc2rPgNjav7IwkpZ/6asknhZplrearKN+4pUkq9rVuUdwh5eTMDDA9LVrg/CUG4
	/d//OpKQgmfcWdVfrpb3FMQKVAcoDyCNT2g0dYlvnLj8glywkLuQJpZ4+fEeeNj5CBM
	F3ptGFh38U7yLpHy7N4T+oiSFw+OmRvYwgD8HqWU=
Received: by smtp.zohomail.com with SMTPS id 1792564716568879.9171448651128;
	Tue, 20 Oct 2026 23:38:36 -0700 (PDT)
From: vince@palmit.com.au
To: loberman@redhat.com
Cc: linux-scsi@vger.kernel.org, sathya.prakash@broadcom.com,
 sreekanth.reddy@broadcom.com, suganath-prabu.subramani@broadcom.com,
 ranjan.kumar@broadcom.com, James.Bottomley@HansenPartnership.com,
 mkp@kernel.org, MPT-FusionLinux.pdl@broadcom.com,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: mpt3sas: Register devices during SANITIZE
Date: Wed, 21 Oct 2026 16:38:31 +1000
Message-ID: <179256471169.16196.18345735696785515858@palmit.com.au>
In-Reply-To: <20261020210856.42835-1-vince@palmit.com.au>
References: <20261020210856.42835-1-vince@palmit.com.au>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Hi Laurence,
Thanks for your review and for asking about the SANITIZE initiation.

I clarified the drives' history: SANITIZE was started under Linux 6.x
or earlier, and the machine was powered off before it completed.
When the drives were later connected to a Linux 7.x system, the HBA
detected them, but mpt3sas did not register them as SCSI devices.

I have now reproduced the regression with a separate Seagate ST600MP0005
600 GB SAS HDD, serial S7M0ER6F:

1. Linux 6.18.55 LTS: I started SANITIZE OVERWRITE and verified that
   TEST UNIT READY returned NOT READY (02/04/1B), with 0.07% progress.

2. Stock Linux 7.2.11 (unpatched mpt3sas): After rebooting, the HBA
   detected the disk's SAS address (0x5000c5008e53f8e5), but the driver
   repeatedly issued REPORT LUNS / TEST UNIT READY / START UNIT.
   After 145 discovery attempts and 146 START UNIT commands, the disk
   remained absent from both sd and sg device lists. This prevents users
   from monitoring SANITIZE progress and may cause them to mistake a
   healthy drive for a failed one.

3. Patched Linux 7.2.11: After another reboot, the driver correctly
   handled the 02/04/1B condition and immediately registered the same
   disk as /dev/sda (0 B) and /dev/sg0. READ CAPACITY still reported
   SANITIZE IN PROGRESS, and a subsequent REQUEST SENSE progress query
   showed 22.58%. The other SAS disk registered normally throughout.

This confirms that a drive already sanitizing at discovery time becomes
invisible with unpatched 7.2.11, whereas the patched driver registers
it without falsely treating the media as ready.

The controlled reproduction used reboots rather than a separate full
power-cycle test. The original drives had been powered off during
SANITIZE.

I have saved the kernel boot logs, driver build IDs, device inventories,
and the full 145-attempt trace. I can provide them if helpful.

Thanks again for the Reviewed-by!

Best regards,
Vincent YUE

This email and any attachments may contain privileged and confidential information and are intended for the named addressee only. If you have received this e-mail in error, please notify the sender and delete this e-mail immediately. Any confidentiality, privilege or copyright is not waived or lost because this e-mail has been sent to you in error. It is your responsibility to check this e-mail and any attachments for viruses. No warranty is made that this material is free from computer virus or any other defect or error. Any loss/damage incurred by using this material is not the sender's responsibility. The sender's entire liability will be limited to resupplying the material.

