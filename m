From: Michael Reed <mdr@sgi.com>
Subject: Re: [PATCH] fc_transport: stop creating duplicate rport entries.
Date: Tue, 21 Feb 2006 15:52:09 -0600
Message-ID: <43FB8B89.3090702@sgi.com>
References: <20060214222214.GJ2051@andrew-vasquezs-powerbook-g4-15.local> <43F332B2.4000901@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:25298 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S932167AbWBUVwY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Feb 2006 16:52:24 -0500
In-Reply-To: <43F332B2.4000901@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>



James Smart wrote:
> Good Catch!
> 
> -- james s
> 
> Andrew Vasquez wrote:
>> Current fc_transport consumers initially register rports
>> with an UNKNOWN role-state and follow-up with a call to
>> fc_remote_port_rolechg(). 

So, is the above sequence necessary?  Why not just register
the rport with appropriate role and state?  This is what
LSI fusion driver (mptfc) does.  "roles" has target and
initiator set.  (Is fusion broken?)

(Not saying the fix shouldn't be there.)

Mike

<...snip...>

