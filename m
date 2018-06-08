From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 0/2] message: fusion: Fix clang and checkpatch warnings
Date: Thu, 07 Jun 2018 21:33:52 -0400
Message-ID: <yq1fu1y83jz.fsf@oracle.com>
References: <cover.1528342739.git.rvarsha016@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1528342739.git.rvarsha016@gmail.com> (Varsha Rao's message
        of "Thu, 7 Jun 2018 09:17:07 +0530")
Sender: linux-kernel-owner@vger.kernel.org
To: Varsha Rao <rvarsha016@gmail.com>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Nicholas Mc Guire <der.herr@hofr.at>, Lukas Bulwahn <lukas.bulwahn@gmail.com>
List-Id: linux-scsi@vger.kernel.org


Hello Varsha,

> This patchset fixes extraneous parentheses clang warning and few
> checkpatch issues.
>
> Varsha Rao (2):
>   message: fusion: Remove extra parentheses
>   message: fusion: Replace NULL comparison

This is an old driver that's pining for retirement. We generally do not
accept code cleanups for unmaintained code for fear of introducing
regressions.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
