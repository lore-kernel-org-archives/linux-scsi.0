From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: fc class: terminate callback fixes
Date: Sun, 17 Aug 2008 15:54:46 -0500
Message-ID: <48A89016.5080807@cs.wisc.edu>
References: <1215830441-20259-1-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:52847 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751958AbYHQUy5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 17 Aug 2008 16:54:57 -0400
In-Reply-To: <1215830441-20259-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Smart@Emulex.Com

michaelc@cs.wisc.edu wrote:
> This fixes the problems discussed in this thread:
> http://marc.info/?l=linux-scsi&m=121573444523292&w=2
> where we need to call scsi_target_unblock in the code
> path where the terminate call back is used. The unblock calls is
> need so that IO does not get stuck when removing the rport. And for
> the fast IO fail case, I merged the patch to fast fail
> IO so it does not bounce around between the queue
> and driver and is returned to the upper layer quickly.
> These patch then solve all the issues and fix the problem
> for drivers that were not implementing the callback.
> 
> The patches were made over scsi-misc and the qlogic update
> in that thread.
> 

Hey JamesS,

Are these patches ok?
