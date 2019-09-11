Return-Path: <SRS0=uqxd=XG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83619C49ED6
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Sep 2019 21:16:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B0F520578
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Sep 2019 21:16:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729859AbfIKVQV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Sep 2019 17:16:21 -0400
Received: from smtprelay0209.hostedemail.com ([216.40.44.209]:58455 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729781AbfIKVQV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 11 Sep 2019 17:16:21 -0400
X-Greylist: delayed 336 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Sep 2019 17:16:21 EDT
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave02.hostedemail.com (Postfix) with ESMTP id 7C1D318026418
        for <linux-scsi@vger.kernel.org>; Wed, 11 Sep 2019 21:10:46 +0000 (UTC)
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay01.hostedemail.com (Postfix) with ESMTP id 0C0B3100E86C7;
        Wed, 11 Sep 2019 21:10:45 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: stem07_23710a8214614
X-Filterd-Recvd-Size: 1221
Received: from XPS-9350.home (unknown [47.151.152.152])
        (Authenticated sender: joe@perches.com)
        by omf12.hostedemail.com (Postfix) with ESMTPA;
        Wed, 11 Sep 2019 21:10:43 +0000 (UTC)
Message-ID: <51d9807c5881b467e8bb549eecf04c5cb168f0c1.camel@perches.com>
Subject: Re: [PATCH 1/3] docs: scsi: fix typo
From:   Joe Perches <joe@perches.com>
To:     =?ISO-8859-1?Q?Andr=E9?= Almeida <andrealmeid@collabora.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc:     corbet@lwn.net, kernel@collabora.com, krisman@collabora.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com
Date:   Wed, 11 Sep 2019 14:10:42 -0700
In-Reply-To: <20190911203735.1332398-1-andrealmeid@collabora.com>
References: <20190911203735.1332398-1-andrealmeid@collabora.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.32.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2019-09-11 at 17:37 -0300, André Almeida wrote:
> "Busses" is the third person conjugation of verb "to buss" in the
> present tense. "Buses" is the plural of bus, as in "serial bus".

busses and buses are both acceptable plurals of bus

https://www.dictionary.com/browse/bus


