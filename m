From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] Fix error path when adding sysfs attributes
Date: Fri, 16 Jan 2004 11:48:39 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040116194839.GA1053@beaverton.ibm.com>
References: <20040116192801.GT27591@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.130]:725 "EHLO e32.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S265675AbUAPTn3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Jan 2004 14:43:29 -0500
Content-Disposition: inline
In-Reply-To: <20040116192801.GT27591@localhost>
List-Id: linux-scsi@vger.kernel.org
To: Martin Hicks <mort@wildopensource.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

While we are cleaning there appears to also be an extra return on line
364 after a goto. It might be good to include this change in the patch.

-andmike
--
Michael Anderson
andmike@us.ibm.com

