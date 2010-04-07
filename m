From: <lemons_terry@emc.com>
Subject: SCSI persistent reservation terms
Date: Wed, 7 Apr 2010 10:55:49 -0400
Message-ID: <3BEB5F9B6605A140847DEEEDF7439C5D040A06C8@CORPUSMX50A.corp.emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mexforward.lss.emc.com ([128.222.32.20]:10840 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932684Ab0DGO6u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Apr 2010 10:58:50 -0400
Received: from hop04-l1d11-si02.isus.emc.com (HOP04-L1D11-SI02.isus.emc.com [10.254.111.55])
	by mexforward.lss.emc.com (Switch-3.3.2/Switch-3.1.7) with ESMTP id o37Ewm09009103
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 7 Apr 2010 10:58:48 -0400
Received: from mailhub.lss.emc.com (nagas.lss.emc.com [10.254.144.15]) by hop04-l1d11-si02.isus.emc.com (RSA Interceptor) for <linux-scsi@vger.kernel.org>; Wed, 7 Apr 2010 10:58:37 -0400
Received: from corpussmtp4.corp.emc.com (corpussmtp4.corp.emc.com [10.254.169.197])
	by mailhub.lss.emc.com (Switch-3.4.2/Switch-3.3.2mp) with ESMTP id o37EwZnq028924
	for <linux-scsi@vger.kernel.org>; Wed, 7 Apr 2010 10:58:36 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi

I'm trying to understand one aspect of the SCSI persistent reservation =
functionality. SPC-4 mentions the terms 'All Registrants' and 'Registra=
nts Only', and applies these to both 'Write Exclusive' and 'Exclusive A=
ccess'.  Nowhere can I find a definition of what these terms mean.  If =
you would, please point me in the right direction.

Thanks!
tl

Terry Lemons
Backup Recovery Systems Division
EMC=B2
where information lives
4400 Computer Drive, MS D239
Westboro MA 01580
Phone: 508 898 7312
Email: Lemons_Terry@emc.com=20



--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
