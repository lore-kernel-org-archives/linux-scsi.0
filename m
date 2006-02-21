From: Michael Reed <mdr@sgi.com>
Subject: Re: [PATCH] fc_transport: stop creating duplicate rport entries.
Date: Tue, 21 Feb 2006 16:07:22 -0600
Message-ID: <43FB8F1A.2010800@sgi.com>
References: <20060214222214.GJ2051@andrew-vasquezs-powerbook-g4-15.local> <43F332B2.4000901@emulex.com> <43FB8B89.3090702@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:35031 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S932362AbWBUWHe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Feb 2006 17:07:34 -0500
In-Reply-To: <43FB8B89.3090702@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>
Cc: James.Smart@Emulex.Com, Andrew Vasquez <andrew.vasquez@qlogic.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>



Michael Reed wrote:
> 
> James Smart wrote:
>>Good Catch!
>>
>>-- james s
>>
>>Andrew Vasquez wrote:
>>>Current fc_transport consumers initially register rports
>>>with an UNKNOWN role-state and follow-up with a call to
>>>fc_remote_port_rolechg(). 
> 
> So, is the above sequence necessary?  Why not just register
> the rport with appropriate role and state?  This is what
> LSI fusion driver (mptfc) does.  "roles" has target and
> initiator set.  (Is fusion broken?)

WHAT AM I SAYING?  roles is passed in with "target" set
unless the target is also an initiator.

Mike

> 
> (Not saying the fix shouldn't be there.)
> 
> Mike
> 
> <...snip...>
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
