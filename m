From: Alan Stern <stern@rowland.harvard.edu>
Subject: SCSI documentation in scsi_mid_low_api.txt
Date: Thu, 3 Jul 2003 16:20:32 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0307031618140.779-100000@ida.rowland.org>
References: <20030620210725.GB18449@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:2308 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S265346AbTGCUGF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jul 2003 16:06:05 -0400
In-Reply-To: <20030620210725.GB18449@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

Mike:

Here's a suggestion to improve the documentation in scsi_mid_low_api.txt.  
In the sections that list the API functions and give their descriptions, 
add a line mentioning whether the function might block.  Right now there's 
no easy way to tell which ones can be called in interrupt context or with 
a spinlock held and which ones can't.

Alan Stern

