From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH RFC 1/2] add transport scan callout to fix sysfs layout
 when scanning from userspace
Date: Tue, 24 May 2005 17:41:49 -0700
Message-ID: <4293C9CD.6030801@cs.wisc.edu>
References: <1116711431.6285.28.camel@mina> <20050524230143.GA6407@us.ibm.com> <20050525003044.GA6564@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:2697 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S262191AbVEYAmN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 May 2005 20:42:13 -0400
In-Reply-To: <20050525003044.GA6564@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: linux-scsi@vger.kernel.org, Andrew Vasquez <andrew.vasquez@qlogic.com>, James Smart <James.Smart@Emulex.Com>

Patrick Mansfield wrote:
> 
> Where is iscsi_register_transport? A current git tree? I should probably

subversion tree
svn checkout svn://svn.berlios.de/open-iscsi
Look in kernel/scsi_transport_iscsi.c

http://svn.berlios.de/viewcvs/open-iscsi/kernel/scsi_transport_iscsi.c?rev=338&view=markup
