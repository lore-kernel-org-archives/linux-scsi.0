Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72754C433DB
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jan 2021 00:13:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B5CD236F9
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jan 2021 00:13:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729301AbhAHANH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jan 2021 19:13:07 -0500
Received: from mx2.suse.de ([195.135.220.15]:58578 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729465AbhAHANH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 7 Jan 2021 19:13:07 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1610064741; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TUKjpFkka8YlaRp3r6eTy70dL42hOoWay0pZpyip/vk=;
        b=RqPB1VBWOOp7r1aGkRuh3FT2MLtICEDv7+JHsv6t0yV7b6wG7vTTnxNq0ZQWJkkKU2ZKai
        3+e8nnx8B6FFiQzOCED4cEqaWs52ZOCjDi8Ad9UV1AqiNObJbIva2tNakVowzOxoBtY9AA
        +5kkNqBt/qcg8J2De4oXatmEBsQQyew=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D6AA6ABC4;
        Fri,  8 Jan 2021 00:12:20 +0000 (UTC)
Message-ID: <0ce5cd9c36a687ace29a6e13953af88778027a2b.camel@suse.com>
Subject: Re: [PATCH V3 20/25] smartpqi: update sas initiator_port_protocols
 and target_port_protocols
From:   Martin Wilck <mwilck@suse.com>
To:     Don Brace <don.brace@microchip.com>, Kevin.Barnett@microchip.com,
        scott.teel@microchip.com, Justin.Lindley@microchip.com,
        scott.benesh@microchip.com, gerry.morong@microchip.com,
        mahesh.rajashekhara@microchip.com, hch@infradead.org,
        jejb@linux.vnet.ibm.com, joseph.szczypek@hpe.com, POSWALD@suse.com
Cc:     linux-scsi@vger.kernel.org
Date:   Fri, 08 Jan 2021 01:12:19 +0100
In-Reply-To: <160763257665.26927.9413842131993329952.stgit@brunhilda>
References: <160763241302.26927.17487238067261230799.stgit@brunhilda>
         <160763257665.26927.9413842131993329952.stgit@brunhilda>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.38.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2020-12-10 at 14:36 -0600, Don Brace wrote:
> From: Murthy Bhat <Murthy.Bhat@microchip.com>
> 
> * Export valid sas initiator_port_protocols and
>   target_port_protocols to sysfs.
>   * lsscsi now shows correct values.
> 
> Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
> Reviewed-by: Scott Teel <scott.teel@microchip.com>
> Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
> Signed-off-by: Murthy Bhat <Murthy.Bhat@microchip.com>
> Signed-off-by: Don Brace <don.brace@microchip.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>


