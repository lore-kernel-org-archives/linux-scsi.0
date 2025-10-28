Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91D8F33EC
	for <linux-scsi@vger.kernel.org>; Tue, 28 Oct 2025 07:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761636858; cv=none; b=lEjJoFwpHEZbTYy9lG0fSNh6krCiwzIBRSASnvc2VIhxUzVDgOLTcdhdQkDgLjXm8iTapzNFcG40/fwnSOi0KFvlQUY2Gqjwjng6QWSWEoUzioAndWh8jp7GS2bjdv5Wa/8XdNjIR1LLWL1qU5riX4D4lkWG9vfKsHONWe5snVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761636858; c=relaxed/simple;
	bh=Y0xIbFtD5JJBJaGOmHeZIh2A74bEzbWs5/nPzmfIbuU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uTAX0fbzZp/YId8W5glvLzCvv5eAxtfKVxmVFaclhEMOZsxYZrCcyxhMxdIr9YJ4u1ZeGeN3YChivry8SiYPKZnoq4/x4E4/OVvT6hSBsgkPqXYF9ZV6SLO1EeIDwdHShf7vUvJ3xieX8dNRnTPlWkOxtTk1o0hTFeHBXInGfn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YIeWB7/g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YIeWB7/g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05C8AC4CEE7;
	Tue, 28 Oct 2025 07:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761636858;
	bh=Y0xIbFtD5JJBJaGOmHeZIh2A74bEzbWs5/nPzmfIbuU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=YIeWB7/g1Doft4ajsLXHTFfc691dKie8X+DthBzDrtOx0ecmzAAzyh2p62ue39ifQ
	 aZnxGAUik0PjdvUj6awZ17G1XYF3zGEGGq+l5ktYZjHgi6H7AjoCcanUetVmUKtWxD
	 HD5S+PTBPtn2qczKq/arLvc1SP90eHD+f18VvhlqRTlEGVHrNkXWcD9o1h4jkZUV+I
	 TCWtQKoSvpnW6UTwuNTMicgjlaYzMaqjRlrtQUGdYPludR8IwkFEVkyuhdWYGwzoWU
	 Sg3fVRlbU3Mv+h92NQ+/jWiU8gc20tio8lXJGC9gpq3Y65m70zR0piSe6X4vqsNbZ3
	 UguTVJ/ZyIYyQ==
Message-ID: <921bd950-4e62-4140-a015-c41ea7f07989@kernel.org>
Date: Tue, 28 Oct 2025 08:34:15 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/11] lpfc: Add capability to register Platform Name ID
 to fabric
To: Justin Tee <justintee8345@gmail.com>, linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com, justin.tee@broadcom.com
References: <20251027235446.77200-1-justintee8345@gmail.com>
 <20251027235446.77200-10-justintee8345@gmail.com>
From: Krzysztof Kozlowski <krzk@kernel.org>
Content-Language: en-US
Autocrypt: addr=krzk@kernel.org; keydata=
 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 a/A=
In-Reply-To: <20251027235446.77200-10-justintee8345@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 28/10/2025 00:54, Justin Tee wrote:
> FC-LS and FC-GS specifications outline fields for registering a platform
> name identifier (PNI) to the fabric.  The PNI assists fabrics with
> identifying the physical server source of frames in the fabric.
> 
> lpfc generates a PNI based partially on the uuid specific for the system.
> Initial attempts to extract a uuid are made from SMBIOS's System
> Information 08h uuid entry.  If SMBIOS DMI does not exist, then Open
> Firmware Device-Tree's virtual partition uuid property is used.  Otherwise,
> a PNI is not generated and PNI registration with the fabric is skipped.
> 
> The PNI is submitted in FLOGI and FDISC frames.  After successful fabric
> login, the RSPNI_PNI CT frame is submitted to the fabric to register the OS
> host name tying it to the PNI.
> 
> Signed-off-by: Justin Tee <justin.tee@broadcom.com>

Still does not match From address.

> ---
>  drivers/scsi/lpfc/lpfc.h           |  4 ++
>  drivers/scsi/lpfc/lpfc_ct.c        | 36 +++++++++++++
>  drivers/scsi/lpfc/lpfc_els.c       | 18 +++++--
>  drivers/scsi/lpfc/lpfc_hbadisc.c   |  2 +
>  drivers/scsi/lpfc/lpfc_hw.h        | 25 ++++++++-
>  drivers/scsi/lpfc/lpfc_nportdisc.c |  4 --
>  drivers/scsi/lpfc/lpfc_sli.c       | 83 ++++++++++++++++++++++++++++++
>  7 files changed, 164 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
> index 8459cf568c12..f892bb2d119a 100644
> --- a/drivers/scsi/lpfc/lpfc.h
> +++ b/drivers/scsi/lpfc/lpfc.h
> @@ -633,6 +633,7 @@ struct lpfc_vport {
>  #define FC_CT_RSPN_ID		0x8	 /* RSPN_ID accepted by switch */
>  #define FC_CT_RFT_ID		0x10	 /* RFT_ID accepted by switch */
>  #define FC_CT_RPRT_DEFER	0x20	 /* Defer issuing FDMI RPRT */
> +#define FC_CT_RSPNI_PNI		0x40	 /* RSPNI_PNI accepted by switch */
>  
>  	struct list_head fc_nodes;
>  	spinlock_t fc_nodes_list_lock; /* spinlock for fc_nodes list */
> @@ -1077,6 +1078,9 @@ struct lpfc_hba {
>  
>  	uint32_t nport_event_cnt;	/* timestamp for nlplist entry */
>  
> +	unsigned long pni;		/* 64-bit Platform Name Identifier */
> +#define PATH_UUID_IBM "ibm,partition-uuid"

Where did you document the ABI?

Best regards,
Krzysztof
