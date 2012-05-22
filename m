From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: multipath_busy() stalls IO due to scsi_host_is_busy()
Date: Tue, 22 May 2012 13:31:36 +0900
Message-ID: <4FBB16A8.1020401@ce.jp.nec.com>
References: <4FB39D78.9020300@itwm.fraunhofer.de> <4FB4C065.7070804@ce.jp.nec.com> <4FBA6281.3040109@itwm.fraunhofer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:64327 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959Ab2EVEcJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 May 2012 00:32:09 -0400
In-Reply-To: <4FBA6281.3040109@itwm.fraunhofer.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>, Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hi,

On 05/22/12 00:42, Bernd Schubert wrote:
> On 05/17/2012 11:09 AM, Jun'ichi Nomura wrote:
>> However, when it is target/host that is busy, I think dm should
>> send the request down and let SCSI, which has better knowledge
>> about the shared resource, do appropriate starvation control.
>>
>> Could you try the attached patch?
...
> Thanks, that works fine! I had something else in my mind for multipath, but if this can go into scsi we don't need the multipath patch anymore.
> Are you going to officially submit it (missing signed-off)?

Thank you for testing.
Yes, I'll submit it officially with your Reported-by/Tested-by.

Also, a note suggested by Mike Snitzer will be added to the
patch description. (Thanks Mike.)

-- 
Jun'ichi Nomura, NEC Corporation
