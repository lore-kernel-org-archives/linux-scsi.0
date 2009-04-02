From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Proposal to add sysfs attributes for FCoE in FC Transport layer
Date: Thu, 2 Apr 2009 12:03:58 -0600
Message-ID: <20090402180358.GV8014@parisc-linux.org>
References: <9F784EDD-BC14-4113-B7F2-1E5EBC17B65F@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:56284 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755420AbZDBSEL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Apr 2009 14:04:11 -0400
Content-Disposition: inline
In-Reply-To: <9F784EDD-BC14-4113-B7F2-1E5EBC17B65F@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Giridhar Malavali <giridhar.malavali@qlogic.com>
Cc: linux-scsi@vger.kernel.org, Andrew Vasquez <andrew.vasquez@qlogic.com>, Joe Carnuccio <joe.carnuccio@qlogic.com>, Marcus Barrow <marcus.barrow@qlogic.com>, David Wagner <david.wagner@qlogic.com>

On Tue, Mar 31, 2009 at 06:06:23PM -0700, Giridhar Malavali wrote:
> Current DCBX parameter details:
> 
> PGID (Priority group ID)
> 
> 1) pgid_priority_group_0;       /* Priority group ID of priority group  
> 0 */
> 2) pgid_priority_group_1;       /* Priority group ID of priority group  
> 1 */
> 3) pgid_priority_group_2;       /* Priority group ID of priority group  
> 2 */
> 4) pgid_priority_group_3;       /* Priority group ID of priority group  
> 3 */
> 5) pgid_priority_group_4;       /* Priority group ID of priority group  
> 4 */
> 6) pgid_priority_group_5;       /* Priority group ID of priority group  
> 5 */
> 7) pgid_priority_group_6;       /* Priority group ID of priority group  
> 6 */
> 8) pgid_priority_group_7;       /* Priority group ID of priority group  
> 7 */

There are a lot of places where you've got the same things repeated 8
times.  How about:

hostX/pgY/id
hostX/pgY/bw
hostX/pgY/pfc
hostX/pgY/tx_pause
hostX/pgY/rx_pause
hostX/pgY/tx_priority
hostX/pgY/rx_priority

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
