From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: [PATCH 0/3][RESUBMIT] scsi_dh_rdac: Adding more debug options for
 scsi rdac handler
Date: Fri, 28 Aug 2009 08:22:17 -0600
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF474C65F3C@cosmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og118.obsmtp.com ([64.18.2.8]:50801 "EHLO
	exprod7og118.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254AbZH1OWZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Aug 2009 10:22:25 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "'sekharan@linux.vnet.ibm.com'" <sekharan@linux.vnet.ibm.com>, "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>, "Stankey, Robert" <Robert.Stankey@lsi.com>, "Dachepalli, Sudhir" <Sudhir.Dachepalli@lsi.com>

Hi All,
These patches add more debugging options to scsi rdac device handler. This can considerably reduce the time taken to debug issues in big configurations and also very helpful in addressing the support issues.
Here is the summary of changes. 
- Added a bit mask "module parameter" rdac_logging with 2 bits for each type of logging.
 - currently defined only two types of logging(failover and sense logging). Can be enhanced later if required.
- By default only failover logging is enabled which is equivalent of current logging.

Thanks to Chandra, Vijay and Bob for their useful comments. This code has been tested on 2.6.31-rc5.

Signed-off-by: Babu Moger <babu.moger@lsi.com>
Reviewed-by: Vijay Chauhan <vijay.chauhan@lsi.com>
Reviewed-by: Bob Stankey <Robert.stankey@lsi.com>

