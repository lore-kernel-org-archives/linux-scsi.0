From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] SCSI fixes for 4.15-rc3
Date: Tue, 12 Dec 2017 09:32:02 -0800
Message-ID: <CA+55aFyzrHj+rMN7Ct7xCEWZT=viXYAC1WZjfgFnM_R0tq1n5A@mail.gmail.com>
References: <1513095686.3110.9.camel@HansenPartnership.com>
 <CA+55aFy8hepLBW9Zvfk4MgibG4eHF5qkmon+2Zs6KWLQfFH-fg@mail.gmail.com> <yq1indbq2sb.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1indbq2sb.fsf@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Johannes Thumshirn <jthumshirn@suse.de>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Dec 12, 2017 at 9:22 AM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>
> Arnd and Johannes fixed this up right away:

The commit you point to _is_ the probnlem. It does:

    struct bfad_im_port_s *im_port = shost->hostdata[0];

which is utter bullshit crap.

Notice? It's assigning a pointer (im_port), from an integer value
("hostdata[0]" is "unsigned long").

The code is garbage.

                  Linus
