From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 0/6] scsi tgt
Date: Thu, 16 Feb 2006 13:55:50 -0600
Message-ID: <43F4D8C6.2020300@cs.wisc.edu>
References: <1140119612.20193.46.camel@max>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:51360 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1030635AbWBPTz4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Feb 2006 14:55:56 -0500
Received: from [192.168.0.3] (c-69-180-176-191.hsd1.mn.comcast.net [69.180.176.191])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.1/8.13.1) with ESMTP id k1GJttBl019515
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 16 Feb 2006 13:55:55 -0600
In-Reply-To: <1140119612.20193.46.camel@max>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Mike Christie wrote:
> The following patchset adds the basic infrastructure to support target
> mode in userspace. There are sevreral todo's left. They mostly require
> changes around us like to the packet layer, request queue etc. For
> Jeff's suggestion we are working on the packet layer suggestion, but are
> also looking into relayfs as a possibility.
> 
> This is not ready for mainline. Maybe ready for James to manage it in a
> tree, but not ready for heavy use. With some outstanding patches Tomo
> can install SLES to a scsi tgt LU. But we still need to add a lot of
> functionality to userspace. We basically need to add the state model
> code we just ripped out of the kernel to userspace becuase the current
> code is geared tword working on trying to maintain performance with a
> kernel implementation not add features/requirements like task management
> functions, support for tape and cd, etc.
> 

oh yeah, the patchset was made against scsi-rc-fixes-2.6.
