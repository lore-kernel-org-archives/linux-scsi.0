From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: advansys: Remove unnecessary parentheses
Date: Thu, 20 Sep 2018 23:11:59 -0400
Message-ID: <yq11s9nmtmo.fsf@oracle.com>
References: <20180920205858.6035-1-natechancellor@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180920205858.6035-1-natechancellor@gmail.com> (Nathan
        Chancellor's message of "Thu, 20 Sep 2018 13:58:58 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Nathan Chancellor <natechancellor@gmail.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Hannes Reinecke <hare@suse.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Nathan,

> Clang warns when multiple pairs of parentheses are used for a single
> conditional statement.
>
> drivers/scsi/advansys.c:6451:20: warning: equality comparison with
> extraneous parentheses [-Wparentheses-equality]
>                                 if ((sdtr_data == 0xFF)) {
>                                      ~~~~~~~~~~^~~~~~~
> drivers/scsi/advansys.c:6451:20: note: remove extraneous parentheses
> around the comparison to silence this warning
>                                 if ((sdtr_data == 0xFF)) {
>                                     ~          ^      ~
> drivers/scsi/advansys.c:6451:20: note: use '=' to turn this equality
> comparison into an assignment
>                                 if ((sdtr_data == 0xFF)) {
>                                                ^~
>                                                =
> 1 warning generated.

Applied to 4.20/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
