From: Douglas Gilbert <dougg@torque.net>
Subject: Re: How to map between /dev/sdX and dev/sgX devices?
Date: Fri, 20 Aug 2004 08:07:22 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4125249A.30808@torque.net>
References: <C8CF60CFC4D8A74E9945E32CF096548A022148EC@silver.nane.netapp.com> <1092942751.2820.5.camel@laptop.fenrus.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub2.uq.edu.au ([130.102.149.128]:44047 "EHLO
	mailhub2.uq.edu.au") by vger.kernel.org with ESMTP id S267460AbUHSWIZ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Aug 2004 18:08:25 -0400
In-Reply-To: <1092942751.2820.5.camel@laptop.fenrus.com>
List-Id: linux-scsi@vger.kernel.org
To: arjanv@redhat.com
Cc: "Reilley, Peter" <Peter.Reilley@netapp.com>, linux-scsi@vger.kernel.org

Arjan van de Ven wrote:
> On Thu, 2004-08-19 at 20:35, Reilley, Peter wrote:
> 
>>What is the correct way to find the corresponding scsi generic
>>device given the scsi disk node name?   I have a situation
>>where I must issue SCSI pass thru commands to a specific
>>/dev/sdX node.  
> 
> 
> don't..... use SG_IO on the device directly

and if that breaks your app then try the equivalent
sg device to check that you haven't tripped over another
QOI issue.

Doug Gilbert
