From: "Mun Hamlet" <hamletmun@hotmail.com>
Subject: SCSI problem
Date: Fri, 02 Jun 2006 09:41:15 -0300
Message-ID: <BAY112-F248D459F07921745E672CA0910@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ks_c_5601-1987; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bay112-f2.bay112.hotmail.com ([64.4.26.12]:25422 "EHLO
	hotmail.com") by vger.kernel.org with ESMTP id S1751407AbWFBMlS
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Jun 2006 08:41:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

Today I did some tests

linux-2.6.14-rc3 and linux-2.6.14-rc1 had the same error, but 
linux-2.6.13.5
was fine.
So I guess this bug was introduced between 2.6.13.5 and 2.6.14-rc1

http://bugs.gentoo.org/show_bug.cgi?id=127991


