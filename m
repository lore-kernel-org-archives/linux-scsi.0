Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794943654;
	b=rnqct8QrJ8hWp7t5J9dTH//Lb9ZlZoRrGhsAzYAN9gMhl32cy+egwhxZGDlocqqHkeI9
	 Tkd9fp3Ia9BKAU/mX9qGcM51VOSsHEeOEEBtZaflZQEXP2gxpQX1Wzr+VNjN0jkledbyt
	 4BxP9oxQRXvpbGXiBTmP7obGThVw36p10kztzm+ZgAsKmSy9OnLmhD0NiP9P2otc+qqUR
	 /9OHGfSL3n/o/A3il+WildE9UBE/J2wU6oJhCuGP6FKcS1f2wW0e9R2lAnRV8C4nufuhq
	 UaS2PC3TAX3T6rOsFCro9gfOSpQmGbzUENtKtShnWrUIE9chI7TUcIW6plsOCdAStZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794943654;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=6trCVgkmKXfRuSPpaGIP8afSVy9u9K8tf2EWi/xEbiA=;
	b=KatmDoeebc7c8UwH3foKFNwn5+e72nVpm2bcphvqV/g3E5zFstiwVCYSJub6WMjug6dj
	 Gj9czlnjIYbXVYwFNFDOjt1rVpeloLV7xMW1RjXzAJipf0rAeCmQ/eviEe/zP9S1ZAVtU
	 H57XpPraBfnYc2dXCriADRGzPh3yJhCb/Asc+OIgBud3VPURlS1FV1CkeNlYgY/hYrKen
	 EK47sdPRJoC14VMX6haeQUmtP8M1vESdUuix7Y3dQQuZrtGb6IrjSOCBwYtXPQdWkdoN5
	 TchvkUr2+6e1dQMz9gTJkhxOMbetCAtYgm500k3FVzCLcrCR1Ll6+QWotbsHcAR0e9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=NrjShZss;
	arc=none smtp.remote-ip=199.89.1.16
Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B811606A31C;
	Tue, 17 Nov 2026 19:27:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6B811606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=NrjShZss
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4jTZW96mzNzlfftY;
	Tue, 17 Nov 2026 19:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1794943651; x=1797535652; bh=6trCVgkmKXfRuSPpaGIP8afS
	Vy9u9K8tf2EWi/xEbiA=; b=NrjShZssthusAPqjbF+zgd9xVzOdGuidMqcmbZfv
	9OA62J7p7sOZtTzGnbG5vFXwiXYrg1d8+fjN1sGUPJRF3ABU8+UnPzmakTwm+E1J
	+HnQwqWpQ/AKCO6uRlLljZ9OMOFfm0iU6Q6/qC+enouOaIgh/VZYGZkWQaYWKMkr
	OW5oN/EgH+rtWAgC6nJB9IeTbA5mdCor0VyqrSRX/m5ivbcJrGg86zQ76llicgti
	P0Ax6fszq7ek8ldrVQICACCuqrMmf/3UjAnzwvWbqHzkl7vtzH8HMI/IH2kGvgBF
	ZW/11RTiMRwyhCoZXh8qQoJR/m3YzqL7VgmhBEEiq1eP3A==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id SSrE75kslNOC; Tue, 17 Nov 2026 19:27:31 +0000 (UTC)
Received: from [IPV6:2a00:79e0:2ed2:d:643b:ca6:3ef5:e98] (unknown [104.135.182.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4jTZW70dlrzlfclv;
	Tue, 17 Nov 2026 19:27:31 +0000 (UTC)
Message-ID: <350d2c49-1a12-47e2-8720-8deb8e322531@acm.org>
Date: Tue, 17 Nov 2026 11:27:30 -0800
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: pm8001: Offset hardware queue index for MSI-X
 pre-vector
To: TJ Adams <tadamsjr@google.com>, Jack Wang <jinpu.wang@cloud.ionos.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <mkp@kernel.org>
Cc: John Garry <john.garry@linux.dev>, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261117175558.4146151-1-tadamsjr@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20261117175558.4146151-1-tadamsjr@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/17/26 9:55 AM, TJ Adams wrote:
 > diff --git a/drivers/scsi/pm8001/pm8001_defs.h 
b/drivers/scsi/pm8001/pm8001_defs.h
 > index a9605ca317f3..ef7b6257cc8b 100644
 > --- a/drivers/scsi/pm8001/pm8001_defs.h
 > +++ b/drivers/scsi/pm8001/pm8001_defs.h
 > @@ -178,6 +178,7 @@ enum port_type {
 >  #define	PM8001_MAX_INB_NUM	 64
 >  #define	PM8001_MAX_OUTB_NUM	 64
 >  #define	PM8001_CAN_QUEUE	 508	/* SCSI Queue depth */
 > +#define PM8001_PRE_VECTORS	 1	/* non-affinitized housekeeping vector */

The surrounding definitions have a tab between "#define" and the
macro name, while this one has a space. Is this intentional?

 > -static u32 pm80xx_chip_get_q_index(struct sas_task *task)
 > +static u32 pm80xx_chip_get_q_index(struct pm8001_hba_info *pm8001_ha,
 > +				   struct sas_task *task)
 >  {
 >  	struct request *rq = sas_task_find_rq(task);
 >
 >  	if (!rq)
 >  		return 0;
 >
 > -	return blk_mq_unique_tag_to_hwq(blk_mq_unique_tag(rq));
 > +	if (pm8001_ha->number_of_intr > PM8001_PRE_VECTORS)
 > +		return blk_mq_unique_tag_to_hwq(blk_mq_unique_tag(rq)) +
 > +		       PM8001_PRE_VECTORS;
 > +
 > +	return 0;
 >  }

A side effect of this change: completions for the highest hardware
queue now go to outbound queue max_q_num - 1. pm80xx_chip_init()
programs that vector as the fatal error interrupt. process_oq() reads
MSGU_SCRATCH_PAD_1 for every interrupt on that vector, and also
MSGU_SCRATCH_PAD_RSVD_0 if no fatal error is reported. Without this
patch, no I/O completions go to that queue, so those MMIO reads only
happen for fatal error interrupts. The code is still correct, and the
driver used that queue for I/O before commit 42f22fe36d51 too, but it
might be worth mentioning in the patch description. Alternatively, a
follow-up patch could move the fatal error interrupt to the
housekeeping vector.

Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
