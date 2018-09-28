From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: mptfusion: Remove unnecessary parentheses and simplify null checks
Date: Fri, 28 Sep 2018 02:31:29 -0400
Message-ID: <yq14leab0am.fsf@oracle.com>
References: <20180915063645.31295-1-natechancellor@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180915063645.31295-1-natechancellor@gmail.com> (Nathan
        Chancellor's message of "Fri, 14 Sep 2018 23:36:45 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Nathan Chancellor <natechancellor@gmail.com>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>
List-Id: linux-scsi@vger.kernel.org


Nathan,

> Clang warns when multiple pairs of parentheses are used for a single
> conditional statement.

Applied to 4.20/scsi-queue. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
