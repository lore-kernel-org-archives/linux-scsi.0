From: Zhiqi Tao <zhiqi.tao@oracle.com>
Subject: Land iscsi iser performance patches to upstream
Date: Thu, 16 Dec 2010 17:15:24 +1100
Message-ID: <4D09AE7C.6070708@oracle.com>
References: <20101216050257.GC1263@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:33787 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215Ab0LPGQD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Dec 2010 01:16:03 -0500
Received: from acsinet15.oracle.com (acsinet15.oracle.com [141.146.126.227])
	by rcsinet10.oracle.com (Switch-3.4.2/Switch-3.4.2) with ESMTP id oBG6FxBB018850
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Thu, 16 Dec 2010 06:16:01 GMT
Received: from acsmt354.oracle.com (acsmt354.oracle.com [141.146.40.154])
	by acsinet15.oracle.com (Switch-3.4.2/Switch-3.4.1) with ESMTP id oBG6DcH9029033
	for <linux-scsi@vger.kernel.org>; Thu, 16 Dec 2010 06:15:58 GMT
In-Reply-To: <20101216050257.GC1263@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

Could anyone advise if there is any plan to push these patches to land 
the upstream?

Patch 1/3
http://www.mail-archive.com/linux-scsi@vger.kernel.org/msg14533.html
Patch 2/3
http://www.mail-archive.com/linux-scsi@vger.kernel.org/msg14381.html
Patch 3/3
http://www.mail-archive.com/linux-scsi@vger.kernel.org/msg14398.html


In particular patch 2 and 3 are matching the iscsi_tcp.c values and have 
improved the performance that we got. It will be beneficial to include 
them into the vanilla kernel.

Thanks!
Zhiqi
