From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] mvsas: convert from rough draft to working driver
Date: Tue, 04 Mar 2008 20:59:35 +0200
Message-ID: <47CD9C17.3090508@panasas.com>
References: <20080223131527.GB7942@ubuntu.domain> <47C049C2.2010502@garzik.org> <20080224114806.GA7908@ubuntu.domain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:50532 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932674AbYCDTAG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Mar 2008 14:00:06 -0500
In-Reply-To: <20080224114806.GA7908@ubuntu.domain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ke Wei <kewei.mv@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, qswang@marvell.com, jfeng@marvell.com, qzhao@marvell.com, lil@marvell.com, saeed.bishara@gmail.com, kewei@marvell.com

On Sun, Feb 24 2008 at 13:48 +0200, Ke Wei <kewei.mv@gmail.com> wrote:
> On Sat, Feb 23, 2008 at 11:28:50AM -0500, Jeff Garzik wrote:
>> Ke Wei wrote:
>>> Convert rough draft Marvell 6440 driver to a working driver.
>>> Added support for SAS and SATA devices, hotplug, wide port, and expanders.
>>> This patch is based on:
>>> branch 'mvsas' of 
>>> git.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git
>> Yay!  Perfect patch:  good tech content, applyable to #mvsas, and the 
>> most important part, the driver works :)
>>
>> One minor (though important) detail:  may we assume this patch has the 
>> same Signed-off-by as previous patches?
>>
> 
> Oah, I have no idea how to diff between the previous 5th commit and
> current to use git-format-patch command, so I had to use git-diff to
> create patch. As a result, I format to place my Signed-off-by when
> sending email.
> Jeff, Do you have a good suggestion?  Thank you for your help.

Do you mean you have 5 patches in git that you want to send as
one patch to the list? 
- if so then lets say you are in branch my_branch based off master
  and it has your 5 patches. And lets say you want to keep your
  original 5 patch, but have an alternative one patch for them all.
- $ git-checkout -b my_one_patch my_branch
- $ git-rebase--interactive master
- At this stage you will get your $GIT_EDITOR with a list of your
  5 patches like:
	pick xxxxxxx patch one
	pick yyyyyyy patch two
        ...
  edit the "pick" at start of line to "squash" to all but the first
  patch. Save and exit the editor.
- git will ask you to edit the commit message of the now combined patch,
  in an editor, do so. Verify you have a Signed-off-by:, save and exit.
- Rebase should finish cleanly, leaving you with one patch that can then
  be sent with $ git-format-patch -1.
- If you do $ git-diff my_one_patch my_branch 
	they are identical
- But $ git-log my_one_patch
 	will only have one patch following master
   
Any re-edits of your git history git-rebase--interactive is your
friend.
> 
> Now,
> Signed-off-by: Ke Wei <kewei@marvell.com>
>  
>> Thanks and have a good weekend,
>>
>> 	Jeff
>>
> -

Boaz
