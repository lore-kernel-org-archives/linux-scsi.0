From: Peter Jones <pjones@redhat.com>
Subject: Re: [PATCH 0/3] scsi_dh: Make scsi device handler modules automatically
 inserted
Date: Fri, 17 Jul 2009 10:14:28 -0400
Message-ID: <4A608744.9020002@redhat.com>
References: <20090427180609.22758.93035.sendpatchset@chandra-ubuntu>	 <4A369320.2080202@redhat.com> <1245365306.4286.27.camel@mulgrave.site>	 <4A3BDFE8.3090003@redhat.com> <4A44D37A.10903@redhat.com>	 <1246986723.6277.63.camel@mulgrave.site> <4A538B13.8050809@redhat.com>	 <1246990464.6277.74.camel@mulgrave.site>	 <1246995401.9541.15.camel@chandra-ubuntu>	 <20090708155808.GA31204@infradead.org>  <4A54E65D.8050706@redhat.com>	 <1247690016.9792.5.camel@chandra-ubuntu>	 <1247706999.8632.8.camel@mulgrave.site>	 <1247792476.670.20.camel@chandra-ubuntu> <1247804349.6606.631.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:41170 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934642AbZGQOOr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Jul 2009 10:14:47 -0400
In-Reply-To: <1247804349.6606.631.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: sekharan@linux.vnet.ibm.com, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu, hare@suse.de

On 07/17/2009 12:19 AM, James Bottomley wrote:
> On Thu, 2009-07-16 at 18:01 -0700, Chandra Seetharaman wrote:
>> On Thu, 2009-07-16 at 01:16 +0000, James Bottomley wrote:
>>> On Wed, 2009-07-15 at 13:33 -0700, Chandra Seetharaman wrote:
>>>> James,
>>>>
>>>> Please let us know which way you want us to proceed ?
>>> Yes, propose a mechanism that keeps manual binding but allows the dm-mp
>>> user an exception. 
>> James, this is the current behavior. We wanted to make the binding
>> automatic, hence the patches.
> 
> OK, well then no ... I'm not breaking an unknown number of enterprise
> configurations by forcing a binding where none is wanted or needed.
> Find a way to do what you want while not breaking anyone else.

And what about the patch I sent you that makes the uevent modalias
change depend on a config option?  You've still not commented on it.

-- 
        Peter
