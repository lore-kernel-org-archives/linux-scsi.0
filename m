Received: from mta-03.yadro.com (mta-03.yadro.com [89.207.88.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0A682D9EDE;
	Fri, 27 Jun 2025 17:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.207.88.253
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751046046; cv=none; b=cW0zehMY4eyZ3UNbMAL3aLPDbfnLN3wnNpU1xabqZt/4frDg6JQbWhFD5dTWlRONwOhgHNiec65tTA5CYjPpDC/kAVG/xAjeHlyZd8E9jXcg0yVaqjgHCxvIDg5o/eQYy3JSTfr8miid3d8pqN8VWtZc8nHy73uV5lKIBU6h3Sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751046046; c=relaxed/simple;
	bh=mfJOMC6zuDTeKC7rDUKVimWH/CRUl9SO9RHQNj81TZU=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WkywT3/ptYb7Q9VsT/gr+lj+ImIqMWXPb3WmjeQO2DRkj7Llo7wLfwHuLCsEPBI7ryeGT13hUpZjITUIPZJI5Ip775TuqnVrEsostAjsuUcO+p7DwW8biQqUUZi3mSoR2DQfzgaLJosbMTwpsgbz0DGLv8LS3I7g48tWvikLmrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yadro.com; spf=pass smtp.mailfrom=yadro.com; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=W5DHsBJb; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=DnBIUW6M; arc=none smtp.client-ip=89.207.88.253
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yadro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yadro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="W5DHsBJb";
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="DnBIUW6M"
Received: from mta-03.yadro.com (localhost [127.0.0.1])
	by mta-03.yadro.com (Postfix) with ESMTP id 67831E0007;
	Fri, 27 Jun 2025 20:40:33 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-03.yadro.com 67831E0007
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-04;
	t=1751046033; bh=UdDcVA+mTIznQmx7UexzTv0BETtuUsQx4KRN+coJ2DA=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:From;
	b=W5DHsBJbfdGyeJ7SFXYQGZgdH7wisbzpdI1xQkNSKiLOlDM7meQ/g3qy/AFx3XOzw
	 DMJgEipTv4rR9bj9KcIS/AudGVZkrlo9AehDXsU70t7a2aJuDxn3LIS9tO7m4b0UGp
	 5L5nBcIeniH01l7uD0mr4r60886R3j6IqNVJv5xDoTJLN6OAfnYonPamrzurwIbe9S
	 oeEcyQ3Z5yJpbrz/bGaHXhLK23RNcuJ/J0AeHMsA79KZsH9KX+fdon3/YIBSknWn0i
	 LDnrH3iGZ3bRS/9rSRMsbLb+UD08N8qFIkQsfZYRGCCeBUivmIG7G2V2qS4Cwvx/ug
	 s3NJHOH4pYOpw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-03;
	t=1751046033; bh=UdDcVA+mTIznQmx7UexzTv0BETtuUsQx4KRN+coJ2DA=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:From;
	b=DnBIUW6MRp/gqs+mSUzy/4FHqYlzeZX3fpUxbT2CQ0dWftSRqVCxmmUpCHrXRz5Of
	 VPr0pbVA5L/bpFaDvut1PrcXTmTO37lb+aBq3BL9kYU8sk/Qk3u7XoWQqX7opbYCok
	 0P6XmMZNSy3WcipqLlGJlS6uvHOjnBF8jft7oemuUqZDT7YTNwUxG9UmB/FSoTNEJy
	 AHR2JcnFGPOIgEMs2H0SvV489FHMNtpIc76O3wFYXsiEBvl79gStt5RjebQy7wbCqG
	 KfrVOi2lvFrHfjPXf/fhSbbxe59O0WAN8+LyeruD8ReWsL/uTBGL39r5361v2OxpjD
	 RN91ChZPrGbWg==
Received: from T-EXCH-10.corp.yadro.com (T-EXCH-10.corp.yadro.com [172.17.11.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mta-03.yadro.com (Postfix) with ESMTPS;
	Fri, 27 Jun 2025 20:40:24 +0300 (MSK)
Received: from T-EXCH-12.corp.yadro.com (172.17.11.143) by
 T-EXCH-10.corp.yadro.com (172.17.11.60) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.9; Fri, 27 Jun 2025 20:40:24 +0300
Received: from yadro.com (172.17.34.55) by T-EXCH-12.corp.yadro.com
 (172.17.11.143) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12; Fri, 27 Jun
 2025 20:40:23 +0300
Date: Fri, 27 Jun 2025 20:40:22 +0300
From: Dmitry Bogdanov <d.bogdanov@yadro.com>
To: Maurizio Lombardi <mlombard@redhat.com>
CC: <martin.petersen@oracle.com>, <michael.christie@oracle.com>,
	<linux-scsi@vger.kernel.org>, <target-devel@vger.kernel.org>,
	<mlombard@bsdbackstore.eu>
Subject: Re: [PATCH] target: generate correct string identifiers for PR OUT
 transport IDs
Message-ID: <20250627174022.GA19805@yadro.com>
References: <20250627145229.286252-1-mlombard@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250627145229.286252-1-mlombard@redhat.com>
X-ClientProxiedBy: RTM-EXCH-04.corp.yadro.com (10.34.9.204) To
 T-EXCH-12.corp.yadro.com (172.17.11.143)
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.1.1.8310, bases: 2025/06/27 16:06:00 #27596505
X-KSMG-AntiVirus-Status: NotDetected, skipped
X-KSMG-KATA-Status: Not Scanned
X-KSMG-LinksScanning: NotDetected, bases: 2025/06/27 16:30:00
X-KSMG-Message-Action: skipped
X-KSMG-Rule-ID: 5

On Fri, Jun 27, 2025 at 04:52:29PM +0200, Maurizio Lombardi wrote:
> 
> Fix target_parse_pr_out_transport_id() to
> return a dynamically allocated string representing the
> transport ID in a standardized, human-readable format
> (e.g., naa.xxxxxxxx...) for various SCSI protocol types
> (SAS, FCP, SRP, SBP).

There is no a single standard how to represent TransportId. There are
several standards for the same port address. But TransportId itself is
the single standard to represent different port names in binary format.
So, the most correct solution would be have TransportId for ACLs and
to match them.

> 
> Previously, the function returned a pointer to the raw binary buffer.
> The caller would then compared it to a human-readable string,
> which obviously always failed.
>
> Now, the function constructs a string using kasprintf()
> based on the protocol's offset and format:
> 
> * SAS, FCP, SBP: 64-bit identifier
> * SRP: 128-bit identifier
> * iSCSI: duplicates the iqn string to match the new allocation behavior

The caller compares it with a specifically prepared string buffer by
fabric module in its own way. And they are not corresponded any
standard and, that especially important, to your code.
Mostly that string contains only hex-representation without any prefixes.
You may grep target_setup_session to check which transport
generates what a string.


There was a patch[1] from my old RFC patchset that addressed that
issue. It can not be applied to upstream due to dependencies on other
patches. But a generation of string representation of TransportID is
correct there.
You may get it to create a correct fix, or let me create new patch with
my solution that could be applied to upstream.

[1] https://patchwork.kernel.org/project/target-devel/patch/20220803162857.27770-28-d.bogdanov@yadro.com/

BR,
 Dmitry

> 
> Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
> ---
>  drivers/target/target_core_fabric_lib.c | 22 ++++++++++++++++------
>  drivers/target/target_core_pr.c         |  7 ++++++-
>  2 files changed, 22 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/target/target_core_fabric_lib.c b/drivers/target/target_core_fabric_lib.c
> index 43f47e3aa448..a124cf982a4c 100644
> --- a/drivers/target/target_core_fabric_lib.c
> +++ b/drivers/target/target_core_fabric_lib.c
> @@ -390,7 +390,10 @@ int target_get_pr_transport_id(struct se_node_acl *nacl,
>  const char *target_parse_pr_out_transport_id(struct se_portal_group *tpg,
>                 char *buf, u32 *out_tid_len, char **port_nexus_ptr)
>  {
> -       u32 offset;
> +       u32 offset = 8;
> +       u32 len = 8;
> +       char *prefix;
> +       char hex[40];
> 
>         switch (tpg->proto_id) {
>         case SCSI_PROTOCOL_SAS:
> @@ -399,15 +402,21 @@ const char *target_parse_pr_out_transport_id(struct se_portal_group *tpg,
>                  * for initiator ports using SCSI over SAS Serial SCSI Protocol.
>                  */
>                 offset = 4;
> +               prefix = "naa";
>                 break;
> -       case SCSI_PROTOCOL_SBP:
>         case SCSI_PROTOCOL_SRP:
> +               prefix = "ib";
> +               len = 16;
> +               break;
>         case SCSI_PROTOCOL_FCP:
> -               offset = 8;
> +               prefix = "naa";
> +               break;
> +       case SCSI_PROTOCOL_SBP:
> +               prefix = "eui";
>                 break;
>         case SCSI_PROTOCOL_ISCSI:
> -               return iscsi_parse_pr_out_transport_id(tpg, buf, out_tid_len,
> -                                       port_nexus_ptr);
> +               return kstrdup(iscsi_parse_pr_out_transport_id(tpg, buf,
> +                               out_tid_len, port_nexus_ptr), GFP_KERNEL);
>         default:
>                 pr_err("Unknown proto_id: 0x%02x\n", tpg->proto_id);
>                 return NULL;
> @@ -415,5 +424,6 @@ const char *target_parse_pr_out_transport_id(struct se_portal_group *tpg,
> 
>         *port_nexus_ptr = NULL;
>         *out_tid_len = 24;
> -       return buf + offset;
> +       bin2hex(hex, buf + offset, len);
> +       return kasprintf(GFP_KERNEL, "%s.%s", prefix, hex);
>  }
> diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
> index 70905805cb17..b9b3adc1657d 100644
> --- a/drivers/target/target_core_pr.c
> +++ b/drivers/target/target_core_pr.c
> @@ -1571,6 +1571,7 @@ core_scsi3_decode_spec_i_port(
>                         dest_rtpi = tmp_lun->lun_tpg->tpg_rtpi;
> 
>                         iport_ptr = NULL;
> +                       kfree(i_str);
>                         i_str = target_parse_pr_out_transport_id(tmp_tpg,
>                                         ptr, &tid_len, &iport_ptr);
>                         if (!i_str)
> @@ -1808,6 +1809,7 @@ core_scsi3_decode_spec_i_port(
>                 core_scsi3_tpg_undepend_item(dest_tpg);
>         }
> 
> +       kfree(i_str);
>         return 0;
>  out_unmap:
>         transport_kunmap_data_sg(cmd);
> @@ -1852,6 +1854,7 @@ core_scsi3_decode_spec_i_port(
>                 core_scsi3_nodeacl_undepend_item(dest_node_acl);
>                 core_scsi3_tpg_undepend_item(dest_tpg);
>         }
> +       kfree(i_str);
>         return ret;
>  }
> 
> @@ -3153,7 +3156,7 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
>         struct t10_pr_registration *pr_reg, *pr_res_holder, *dest_pr_reg;
>         struct t10_reservation *pr_tmpl = &dev->t10_pr;
>         unsigned char *buf;
> -       const unsigned char *initiator_str;
> +       const unsigned char *initiator_str = NULL;
>         char *iport_ptr = NULL, i_buf[PR_REG_ISID_ID_LEN] = { };
>         u32 tid_len, tmp_tid_len;
>         int new_reg = 0, type, scope, matching_iname;
> @@ -3526,6 +3529,7 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
>         core_scsi3_update_and_write_aptpl(cmd->se_dev, aptpl);
> 
>         core_scsi3_put_pr_reg(dest_pr_reg);
> +       kfree(initiator_str);
>         return 0;
>  out:
>         if (buf)
> @@ -3538,6 +3542,7 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
> 
>  out_put_pr_reg:
>         core_scsi3_put_pr_reg(pr_reg);
> +       kfree(initiator_str);
>         return ret;
>  }
> 
> --
> 2.47.1
> 
> 
