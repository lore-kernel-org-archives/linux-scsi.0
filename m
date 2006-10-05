From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Symbol conflict in QLA drivers
Date: Thu, 05 Oct 2006 11:13:32 -0500
Message-ID: <1160064812.17994.30.camel@mulgrave.il.steeleye.com>
References: <29174.1160055701@warthog.cambridge.redhat.com>
	 <20061005142710.GA8141@ranandlinuxbox.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:14817 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751582AbWJEQNz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Oct 2006 12:13:55 -0400
In-Reply-To: <20061005142710.GA8141@ranandlinuxbox.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ravianand <ravi.anand@qlogic.com>
Cc: David Howells <dhowells@redhat.com>, linux-driver@qlogic.com, linux-scsi@vger.kernel.org

On Thu, 2006-10-05 at 07:27 -0700, ravianand wrote:
> We will push a patch to fix it in qla4xxx driver.

Actually, if the symbol can't be made static, please fix both (say with
a qla2/qla4 prefix or something) just so we don't get clashes with other
areas of the kernel.

James


