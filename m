From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: ->proc_info in host template
Date: Wed, 30 Apr 2008 01:01:55 +0400
Message-ID: <20080429210154.GA28259@martell.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.184]:19571 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754876AbYD2UGe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Apr 2008 16:06:34 -0400
Received: by nf-out-0910.google.com with SMTP id d3so115793nfc.21
        for <linux-scsi@vger.kernel.org>; Tue, 29 Apr 2008 13:06:32 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I plan to remove ->read_proc from proc code and this will involve
->proc_info hook in host templates. It's marked "OBSOLETE". Is it
obsoleted as in "will be removed" or obsoleted as in "no new such
hooks"? Should I convert them to ->proc_fops or just remove?
I suspect the former, in this case it will look like

	#ifdef CONFIG_PROC_FS
		const struct file_operations *proc_fops;
	#endif

OK with that?

