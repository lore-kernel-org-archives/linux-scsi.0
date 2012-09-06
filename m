From: Michael Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 0/12] qla4xxx: Updates for scsi "misc" branch.
Date: Thu, 6 Sep 2012 11:09:01 -0500
Message-ID: <793EDE7C-F581-4CAD-96D0-58467267530F@cs.wisc.edu>
References: <1345636510-23131-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0 (Mac OS X Mail 6.0 \(1486\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:37603 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758536Ab2IFQJL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Sep 2012 12:09:11 -0400
In-Reply-To: <1345636510-23131-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vikas.chaudhary@qlogic.com
Cc: jbottomley@parallels.com, linux-scsi@vger.kernel.org, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com


On Aug 22, 2012, at 6:54 AM, vikas.chaudhary@qlogic.com wrote:
> Vikas Chaudhary (12):
>      qla4xxx: Update function name from 8xxx to 82xx
>      qla4xxx: Update structure and variable names
>      qla4xxx: Update func name from ql4_ to qla4_
>      qla4xxx: Rename macros from 82XX to 8XXX
>      qla4xxx: Clean-up and optimize macros
>      qla4xxx: Added new functions in isp_ops
>      qla4xxx: Replace all !is_qla8022() with is_qla40XX()
>      qla4xxx: Set IDC version in correct way
>      qla4xxx: Added new function qla4_8xxx_get_minidump
>      qla4xxx: Added support for ISP83XX
>      qla4xxx: Update Copyright header
>      qla4xxx: Update driver version to 5.03.00-k0


Patches look ok overall. There are some minor coding style issues in patch 10.
- do not need a "return" statement at the end of a function that does not return something
- some people do not like a extra newlines like this:

x = something;

if (x == something else)

but I think it would be ok to clean those up later since they are minor.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>

