From: Or Gerlitz <ogerlitz@voltaire.com>
Subject: Re: Land iscsi iser performance patches to upstream
Date: Tue, 4 Jan 2011 09:22:09 +0200
Message-ID: <4D22CAA1.5060600@voltaire.com>
References: <20101216050257.GC1263@parisc-linux.org>	<4D09AE7C.6070708@oracle.com> <4D224E7B.5040704@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fwil.voltaire.com ([193.47.165.2]:19321 "EHLO
	Exil2010.voltaire.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750831Ab1ADHWK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Jan 2011 02:22:10 -0500
In-Reply-To: <4D224E7B.5040704@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Zhiqi Tao <zhiqi.tao@oracle.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org

On 12/16/2010 12:15 AM, Zhiqi Tao wrote:
>> In particular patch 2 and 3 are matching the iscsi_tcp.c values and 
>> have improved the performance that we got. It will be beneficial to 
>> include  them into the vanilla kernel.
When saying "patch 2 and 3 have improved the performance that we got" - 
did you mean the performance with iser or with iscsi-tcp? if with iser, 
can you spare few words on the test and what was the performance 
improvement?

These patches allow to support e.g 1MB size commands, vs. the 512KB 
limit of the upstream bits, however, we manage to see peak performance 
with much IO sizes (e.g 128KB, 256KB), so I wasn't sure what these 
patches could buy you performance wise.

Or.
