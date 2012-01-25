From: Hannes Reinecke <hare@suse.de>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] [ATTEND] Storage management (API & Library)
Date: Wed, 25 Jan 2012 14:09:35 +0100
Message-ID: <4F1FFF0F.1030007@suse.de>
References: <4F19A981.4080502@redhat.com> <1327157825.2748.5.camel@dabdike.int.hansenpartnership.com> <4F1D8913.1060709@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59823 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751357Ab2AYNJh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Jan 2012 08:09:37 -0500
In-Reply-To: <4F1D8913.1060709@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: tasleson@redhat.com
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, lsf-pc@lists.linux-foundation.org, linux-scsi@vger.kernel.org

On 01/23/2012 05:21 PM, Tony Asleson wrote:
> On 01/21/2012 08:57 AM, James Bottomley wrote:
[ .. ]
>> The second might be what would it take to get vendors interested in
>> doing the array plugin glue.
> 
> By providing:
> * Permissive license (LGPL)
> * Easy to use out of process plug-in support to allow proprietary
> plug-ins (IPC is abstracted)
> * Language agnostic plug-in support (initial support is C and python)
> 
> We are hoping we can get hardware vendors interested in providing their
> own plug-ins.  If anyone has additional ideas, we would certainly like
> to discuss them.
> 
The various hardware vendors already have the means of managing their
arrays, in most cases also providing a CLI.
I would be hoping we could draft the API support such that we can
use the existing tools, without the need of special plug-ins.

Cheers,

Hannes
