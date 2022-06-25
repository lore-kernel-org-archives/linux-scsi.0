Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68653C43334
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Jun 2022 22:24:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233351AbiFYWYq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 25 Jun 2022 18:24:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230246AbiFYWYp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 25 Jun 2022 18:24:45 -0400
X-Greylist: delayed 301 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 25 Jun 2022 15:24:44 PDT
Received: from mout.perfora.net (mout.perfora.net [74.208.4.196])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AB2B13D51
        for <linux-scsi@vger.kernel.org>; Sat, 25 Jun 2022 15:24:44 -0700 (PDT)
Received: from [192.168.0.212] ([108.168.115.3]) by mrelay.perfora.net
 (mreueus004 [74.208.5.2]) with ESMTPSA (Nemesis) id 1N63qG-1ncbNW1egq-016M2g
 for <linux-scsi@vger.kernel.org>; Sun, 26 Jun 2022 00:19:42 +0200
Message-ID: <0a7c3531-94f7-745e-020c-14b7bec7cef6@mdevsys.com>
Date:   Sat, 25 Jun 2022 18:19:39 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
To:     linux-scsi@vger.kernel.org
Reply-To: tomkcpr@mdevsys.com
Content-Language: en-US
From:   TomK <tomkcpr@mdevsys.com>
Subject: Qlogic Cards : LIO support
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:f4qdiVCZQM/B2jkrmIGND6h84sNt9z9thcmyEe9aidNXg2rrccf
 1+DITBWFQjWgsESocYGUFd42bcGpxvURCkvwtXMN6zDNjmdbveTsj9OphsLmAXw+pv/aIHQ
 nvdFb9AiYM5tmTwmj5kAzwfbAIp4Ywd/dSO8PrpReePhBqCbiLORyCi3qJd1xjIwOig7fgD
 SYO8RayQ3T/jelHjPMrWQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:9A3uyjo1upI=:PWO2+kmY3/LdQgV6MZjygN
 Tm1t2M6MDFDbwqYu+IIvrNmmJME4h+D+CG2hpB3pQ3RrFNS1tkIZVRL7jH6pyvqBXGbQwrdTy
 eqkcwIO3fArN6gzvxbL6Hr6kAp9+Q8UP1LPaqvNsgNjlDzQGK6k6jWNXcPavZcicZUZXaBqxw
 BS5GJqsNdCR/S3jImNXa5ZNhIkeypEt2OIMervw8Is1w4+578z1pJffEg5b5szJf63AWnEuLc
 3HqPgejH0/sPxjob8BsxhFbPgen1dFE7eo09R+M/tJInKxUyQ9mjb76jOm2m9tEPDYREMv8jD
 h+yrb9kMcylCMdgp91cUI1je90J7eLY3eUt0PuYknBqXmoUg9YCZpFeLfICIQJAhDikHlsb31
 YosDCFLajYlmATeWXN4x9HxDVFdJ/iXZK9S4n03hHXfMOig8o4+VTu9qeVzlhYFFHck7fC+l7
 r5ePsE0Gk7aJVPbSdIDWc1wE8tSZIQ1R1wuwXCA+jl8JEMD+KaqjD8v1GuhAaruZeIWGNpKVE
 qd/1GzwyYOpXU3GW93W4MpDwhwbcND3YMDo2MtkKSE9cDV/x6fHNdhzNsFRb+xSI3Ug+Y8ayJ
 0By9oqqxLUqbR77xCgUOMTey+NZVY9OmVOBvEqClDn8i1OJqH4i8oWeFW/LLKoPxbuoH+xQBe
 nQqo+tStHzrrxi989ZDpE0/zWOetT6OXHS23tFbNv0qMPHTKYgUZS0aJlH4DAWCyGU4bnp+rz
 0pYGIj2JxFYPXBx6359Z4SH87OwElD7BN3yWtA==
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hey There,

Been using LIO with with a few 4GB Qlogic cards.  They have been working 
very well. However, these are non-branded Qlogic cards.

Trying to purchase a couple Qlogic 8GB cards but noticing some are IBM, 
HP, EMC, Dell, NetApp etc.

Now I'm looking for a genuine non-branded 8GB Qlogic card.  Not all 
sellers declare them as branded or not however.

Is there a way to tell from the serial numbers, such us by LFD or RFD 
prefixes if a card is branded or not branded?  Is there an online tool 
to determine branded vs non-branded cards?

Some examples:

LFD1139T91853

LFD1032E51241

LFD1039H03190

RFD1210Y96605

-- 
Thx,
TK.
