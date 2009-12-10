From: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
Subject: Re: [PATCH 4/5] BNX2I - Task management ABORT TASK fixes
Date: Wed, 09 Dec 2009 20:44:03 -0600
Message-ID: <4B206073.9060107@cs.wisc.edu>
References: <1260214829.31468.99.camel@anilgv-desktop>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <3fmAgSwgLCkoyuotmqxoo4.8u4o.qp601qz-u4o4us00sxqs30614.o0y-JX7+OpRa80S8N/ZHIG5xj07CuiCeIGUxQQ4Iyu8u01E@public.gmane.org>
In-Reply-To: <1260214829.31468.99.camel@anilgv-desktop>
List-Post: <http://groups.google.com/group/open-iscsi/post?hl=>,
	<mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/?hl=>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/open-iscsi?hl=>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Unsubscribe: <http://groups.google.com/group/open-iscsi/subscribe?hl=>,
	<mailto:open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Subscribe: <http://groups.google.com/group/open-iscsi/subscribe?hl=>,
	<mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
To: Anil Veerabhadrappa <anilgv-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: James.Bottomley-l3A5Bk7waGM@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, mchan-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, poswald-Et1tbQHTxzrQT0dZR+AlfA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Anil Veerabhadrappa wrote:
>     * Due to typo error driver was failing TMF Abort Task request
>       when ctask->sc != NULL. Fixed code to fail TMF ABORT Task
>       request only when ctask->sc == NULL
>     * Clear age component (19 most significant bits) of reference ITT
>       carried in iSCSI TMF PDU. Age component is internal to initiator
>       side and only lower bits of ITT as defined by ISCSI_ITT_MASK is
>       is sent on wire
>     * Retrieve LUN directly from the ref_sc and update SQ wqe as per
>       chip HSI (Host Software Interface) specification
> 
> Signed-off-by: Anil Veerabhadrappa <anilgv-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>


Looks ok

Reviewed-by: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>

--

You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To unsubscribe from this group, send email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
For more options, visit this group at http://groups.google.com/group/open-iscsi?hl=en.
