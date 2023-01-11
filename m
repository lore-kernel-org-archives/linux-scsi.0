Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBA0BC46467
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Jan 2023 11:57:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233079AbjAKL5X (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Jan 2023 06:57:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232664AbjAKLzu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jan 2023 06:55:50 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 224213631A;
        Wed, 11 Jan 2023 03:49:45 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 8365D4780;
        Wed, 11 Jan 2023 11:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1673437783; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=ghqUcxg9FcKck0SVZ+GPhcOgqDHbAjj1Lcy4shAMxtU=;
        b=1b9FNfULXbF4zKzFs6oNlq8ghnE8lbi/0jzKT3kMyOPbpBp5igM2L1lWwR7TyVGCHBtSWV
        5NUnXresvFLts2WCsWuZ6upEBUJfTi722xmhphRmwF7uGDoiCEh8rTPTpLzGzbuv51bVUG
        +P7shv4pji9lcV7ErgyOaKubzAwcork=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1673437783;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=ghqUcxg9FcKck0SVZ+GPhcOgqDHbAjj1Lcy4shAMxtU=;
        b=rF12AgP3ADEOSGgBhI7qiptyz8PBaVH1l3ZO2AsdsSdMnbTk/++ilnCBJLweWhUzqZYtFq
        G4opZU/6V3PnSRBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 694AD1358A;
        Wed, 11 Jan 2023 11:49:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id n6jiGFeivmOwMwAAMHmgww
        (envelope-from <hare@suse.de>); Wed, 11 Jan 2023 11:49:43 +0000
Message-ID: <06e4d03c-3ecf-7e91-b80e-6600b3618b98@suse.de>
Date:   Wed, 11 Jan 2023 12:49:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
To:     lsf-pc@lists.linux-foundation.org,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Content-Language: en-US
From:   Hannes Reinecke <hare@suse.de>
Subject: [LSF/MM/BPF TOPIC] Limits of development
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi all,

given the recent discussion on the mailing list I would like to propose 
a topic for LSF/MM:

Limits of development

In recent times quite some development efforts were left floundering 
(Non-Po2 zones, NVMe dispersed namespaces), while others (like blk-snap) 
went ahead. And it's hard to figure out why some projects are deemed 
'good', and others 'bad'.

I would like to have a discussion at LSF/MM about what are valid reasons 
for future developments, and maybe even agree on common guidelines where 
developers can refer to when implementing new features.

Cheers,

Hannes
