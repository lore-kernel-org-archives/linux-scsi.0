From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Toshiba USB disk stopped working in 3.10.3
Date: Mon, 05 Aug 2013 22:59:11 -0400
Message-ID: <yq17gfz34ow.fsf@sermon.lab.mkp.net>
References: <20130804234931.1d792792@wc1>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41115 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753566Ab3HFC7U (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Aug 2013 22:59:20 -0400
In-Reply-To: <20130804234931.1d792792@wc1> (Giuliano Pochini's message of
	"Sun, 4 Aug 2013 23:49:31 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Giuliano Pochini <pochini@shiny.it>
Cc: linux-scsi@vger.kernel.org

>>>>> "Giuliano" == Giuliano Pochini <pochini@shiny.it> writes:

Giuliano,

Giuliano> My Toshiba 1TB Stor.e basics does not work anymore since
Giuliano> 3.10.3. I have another USB3 disk which works fine. 

Do the following two patches fix your problem?

http://marc.info/?l=linux-scsi&m=137523956310061&w=2
http://marc.info/?l=linux-scsi&m=137536767805820&w=2

-- 
Martin K. Petersen	Oracle Linux Engineering
