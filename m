From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [GIT PULL] SCSI fixes for 4.15-rc3
Date: Tue, 12 Dec 2017 12:37:07 -0500
Message-ID: <yq1efnzq24c.fsf@oracle.com>
References: <1513095686.3110.9.camel@HansenPartnership.com>
        <CA+55aFy8hepLBW9Zvfk4MgibG4eHF5qkmon+2Zs6KWLQfFH-fg@mail.gmail.com>
        <yq1indbq2sb.fsf@oracle.com>
        <CA+55aFyzrHj+rMN7Ct7xCEWZT=viXYAC1WZjfgFnM_R0tq1n5A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFyzrHj+rMN7Ct7xCEWZT=viXYAC1WZjfgFnM_R0tq1n5A@mail.gmail.com>
        (Linus Torvalds's message of "Tue, 12 Dec 2017 09:32:02 -0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Johannes Thumshirn <jthumshirn@suse.de>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


Linus,

> The commit you point to _is_ the probnlem. It does:
>
>     struct bfad_im_port_s *im_port = shost->hostdata[0];
>
> which is utter bullshit crap.

Sorry, wrong commit:

https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git/commit/?h=fixes&id=48d83282db077f93b2cf40de120f4d6f29eb293b

-- 
Martin K. Petersen	Oracle Linux Engineering
