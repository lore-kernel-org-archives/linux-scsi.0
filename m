From: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH V4 04/11] megaraid_sas: SAS3.5 Generic Megaraid Controllers
 Stream Detection and IO Coalescing (fwd)
Date: Wed, 7 Dec 2016 20:58:43 +0100 (CET)
Message-ID: <alpine.DEB.2.20.1612072056520.2027@hadrien>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
Cc: jejb@kernel.org, hch@infradead.org, linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, linux-kernel@vger.kernel.org, christopher.owens@broadcom.com, kiran-kumar.kasturi@broadcom.com, thenzl@redhat.com, sasikumar.pc@broadcom.com, kbuild-all@01.org
List-Id: linux-scsi@vger.kernel.org

The code on lines 1744 and 1749 seems to need to be indented more.  1744
should be lined up with the inside of the first ( and the comment and the
continue should be indented.

julia



---------- Forwarded message ----------
Date: Wed, 7 Dec 2016 12:14:15 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: kbuild@01.org
Cc: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH V4 04/11] megaraid_sas: SAS3.5 Generic Megaraid Controllers
    Stream Detection and IO Coalescing

In-Reply-To: <1481065220-18431-5-git-send-email-sasikumar.pc@broadcom.com>

Hi Sasikumar,

[auto build test WARNING on scsi/for-next]
[also build test WARNING on next-20161206]
[cannot apply to v4.9-rc8]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Sasikumar-Chandrasekaran/megaraid_sas-Updates-for-scsi-next/20161207-102153
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
:::::: branch date: 2 hours ago
:::::: commit date: 2 hours ago

>> drivers/scsi/megaraid/megaraid_sas_fusion.c:1749:3-12: code aligned with following code on line 1750

git remote add linux-review https://github.com/0day-ci/linux
git remote update linux-review
git checkout c919127dc789eec06ff5e34e06ebb05ef30dbb5e
vim +1749 drivers/scsi/megaraid/megaraid_sas_fusion.c

c919127d Sasikumar Chandrasekaran 2016-12-06  1743  			if ((io_info->ldStartBlock != current_sd->next_seq_lba) &&
c919127d Sasikumar Chandrasekaran 2016-12-06  1744  			((!io_info->isRead) || (!is_read_ahead)))
c919127d Sasikumar Chandrasekaran 2016-12-06  1745  			/*
c919127d Sasikumar Chandrasekaran 2016-12-06  1746  			* Once the API availible we need to change this.
c919127d Sasikumar Chandrasekaran 2016-12-06  1747  			* At this point we are not allowing any gap
c919127d Sasikumar Chandrasekaran 2016-12-06  1748  			*/
c919127d Sasikumar Chandrasekaran 2016-12-06 @1749  			continue;
c919127d Sasikumar Chandrasekaran 2016-12-06 @1750  			cmd->io_request->RaidContext.raid_context_g35.stream_detected
c919127d Sasikumar Chandrasekaran 2016-12-06  1751  				= true;
c919127d Sasikumar Chandrasekaran 2016-12-06  1752  			current_sd->next_seq_lba =
c919127d Sasikumar Chandrasekaran 2016-12-06  1753  			io_info->ldStartBlock + io_info->numBlocks;

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
