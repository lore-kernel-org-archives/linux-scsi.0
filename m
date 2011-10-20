From: Wayne Boyer <wayneb@linux.vnet.ibm.com>
Subject: Re: [RESEND][PATCH 1/1] ipr: add definitions for additional adapter
Date: Thu, 20 Oct 2011 12:24:27 -0700
Message-ID: <4EA0756B.2060501@linux.vnet.ibm.com>
References: <20111019230016.134176494@linux.vnet.ibm.com> <4EA04B8E.9030909@linux.vnet.ibm.com> <1319133843.10746.24.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:33390 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295Ab1JTT3Z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Oct 2011 15:29:25 -0400
Received: from /spool/local
	by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <wayneb@linux.vnet.ibm.com>;
	Thu, 20 Oct 2011 13:25:11 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p9KJOTF3048430
	for <linux-scsi@vger.kernel.org>; Thu, 20 Oct 2011 13:24:32 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p9KJOSj0005757
	for <linux-scsi@vger.kernel.org>; Thu, 20 Oct 2011 13:24:28 -0600
In-Reply-To: <1319133843.10746.24.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Brian King <brking@linux.vnet.ibm.com>, Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>, Wendy Xiong <wenxiong@linux.vnet.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>

On 10/20/2011 11:04 AM, James Bottomley wrote:
> On Thu, 2011-10-20 at 09:25 -0700, Wayne Boyer wrote:
>> Add the appropriate definitions and table entry for an additional adapter.
> 
> This is the same patch except that the description is less
> descriptive ... is there some reason for that?
> 

Yes, the reason is that the name used in the first patch
is an internal name. It won't be used outside of IBM and we
don't want to cause any confusion.

Wayne


