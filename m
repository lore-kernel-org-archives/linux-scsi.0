Return-Path: <SRS0=tdrW=XY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	HK_RANDOM_FROM,HK_RANDOM_REPLYTO,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D5EDC4360C
	for <linux-scsi@archiver.kernel.org>; Sun, 29 Sep 2019 04:53:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F24F5217F5
	for <linux-scsi@archiver.kernel.org>; Sun, 29 Sep 2019 04:53:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725958AbfI2ExG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 29 Sep 2019 00:53:06 -0400
Received: from mout.perfora.net ([74.208.4.196]:60371 "EHLO mout.perfora.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbfI2ExG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 29 Sep 2019 00:53:06 -0400
X-Greylist: delayed 302 seconds by postgrey-1.27 at vger.kernel.org; Sun, 29 Sep 2019 00:53:06 EDT
Received: from [192.168.0.76] ([108.168.115.11]) by mrelay.perfora.net
 (mreueus001 [74.208.5.2]) with ESMTPSA (Nemesis) id 0MLPtc-1iEz5c4C82-000bak
 for <linux-scsi@vger.kernel.org>; Sun, 29 Sep 2019 06:48:03 +0200
To:     linux-scsi@vger.kernel.org
Reply-To: tomkcpr@mdevsys.com
From:   TomK <tomkcpr@mdevsys.com>
Subject: Pick up new LUN size.
Message-ID: <9115cdea-f419-e155-0f9a-2f0dedafef0e@mdevsys.com>
Date:   Sun, 29 Sep 2019 00:48:01 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:QtSZYYJ33gwjxg7bz1z4HXX4FZWp+Arg+z9ymA5IbQHv7WW339t
 aygUEWJWUO0FwaTZekwvrXrvWNXWT4cK9vkpFbETJPyvcr0nis5OpOlKn2lKmCAsimMqeuL
 KQiBca7Eg1cYN+q1GvJ+gC0wR8+WbXRGIwUUwSU7oHBY+6mdwHzxwpriAHHkJazZWAMMjuy
 ex+rP+qzROdmEui57EPYw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:P6WC13UB49s=:QLP1r3nfhzW9tdoAYbxa/4
 wru5IBCpQb6FzHixBCw0NKmLY2f2gsP8GGNbw7e8WHBV1Br0wIiDpOut0cH5v7mK1sMYqe1N0
 gbUe5vnQJuBgVDXp3Gg062g089bY4+9Y+5pTBADrvv8d+/Uu/P5Xxaio7II/N/k0+rxOQeQe/
 QkViO6Bq+q5DWjsFF6FD0F8hoRdldisfkEvu04SVa5M47yAE/Fq4TWix4M+RYQoqxmjzVsN9Z
 4BCtdwnNIyY6F5DuDYTztgpaVsR/uWM0ZvVuu9Yx8Noq3Ub+//HEBndXN4LjUxpMsLI8ZpqAW
 PfHIJFKDFsL44FOsEhPgWIHMdmdXdIKCpUK90gpc0ECz8tv8h6gEEc/xseRqje9M44K8e8Cpx
 evjyuzH/8XFEF7hLEpqTSXbKeduPUM2kJFkjjHxdTuAFLb1Y4Z1S1XPnjszkzmqMkeNr3CKhP
 0JN9FnE/Y2j3CV1ElSWYY9g9t5C6EjgWkhLelW7BauNLuChGcIFs/mACoKk5IeTw1m57EdDYs
 0Jahz7awJUhuLqXLVyJbsZTsvu4SvVqoBK/Y7Xcb5PSVduoYWyqW69418dBFUDILN9RgkqMdd
 MxB0/51bMaziV5wOfHPSHNG9nTBMEma799Up+sclVoprOz9e9oHEX+I2P83SPrSiLqq1v4QEn
 PvEKeaUhTisLY9JvAQELPdiNpqZ4YDk6r3sGeomPqChOKdxrnyRo4StHj+9oOsgOQWtwJ8o5x
 Bm+Qiw4r2LizTlkRyGjpyGapjvlM/9opi1qEbNx0+F1+N99zRS6J2fFpZgdFmA3KaFpf6ROlD
 KrY9p8cyJaILaMCbWVUP5s9Uw113pRJLwAGCcqA0/AL4fRy4qECdldD+acdTxs6M6eMES261J
 fvDx4jbiMbMqvde8KJ//zHqjdOm5Q7C4ETDJst6h8=
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hey All,

I've changed the size of /mnt/luns/san-luns/host01-disk01.img on disk. 
Now I would like to change the size visible in targetcli.  How could I 
do that?

/backstores/fileio> ls
o- fileio 
...................................................................................................... 
[4 Storage Objects]
   o- host01-disk01.img ........................................ [2.0T, 
/mnt/luns/san-luns/host01-disk01.img, in use]
/backstores/fileio>


-- 
Thx,
TK.
