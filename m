From: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
Subject: Re: [PATCH 2/5] BNX2I: Added support for other TMFs besides ABORT_TASK
Date: Wed, 11 Aug 2010 14:07:07 -0500
Message-ID: <4C62F4DB.8070006@cs.wisc.edu>
References: <Eddie Wai <eddie.wai@broadcom.com> <1281467374-6182-3-git-send-email-eddie.wai@broadcom.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Return-path: <open-iscsi+bncCLPJla3WGRDa54vjBBoECwdGLA-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <1281467374-6182-3-git-send-email-eddie.wai-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Post: <http://groups.google.com/group/open-iscsi/post?hl=en_US>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/?hl=en_US>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/open-iscsi?hl=en_US>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/open-iscsi/subscribe?hl=en_US>,
 <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://groups.google.com/group/open-iscsi/subscribe?hl=en_US>,
 <mailto:open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
To: Eddie Wai <eddie.wai-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: James Bottomley <JBottomley-Et1tbQHTxzrQT0dZR+AlfA@public.gmane.org>, open-iscsi <open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Chan <mchan-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Anil Veerabhadrappa <anilgv-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Ben Li <benli-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 08/10/2010 02:09 PM, Eddie Wai wrote:
> +		/* Retrieve LUN directly from the ref_sc */
> +		int_to_scsilun(ref_sc->device->lun,
> +			       (struct scsi_lun *) scsi_lun);
> +		tmfabort_wqe->lun[0] = be32_to_cpu(scsi_lun[0]);
> +		tmfabort_wqe->lun[1] = be32_to_cpu(scsi_lun[1]);
> +



> +	default:
> +		memcpy(tmfabort_wqe->lun, tmfabort_hdr->lun, 8);

Why do you copy the lun differently?

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To unsubscribe from this group, send email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
For more options, visit this group at http://groups.google.com/group/open-iscsi?hl=en.
