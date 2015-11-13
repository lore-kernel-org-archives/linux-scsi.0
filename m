From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] target updates for v4.4-rc1
Date: Fri, 13 Nov 2015 09:38:13 -0800
Message-ID: <CA+55aFwnX0VnRyZ5qJ-O4Dd5KZPxJP1bbSnJXbeyeTnZ-4dXvQ@mail.gmail.com>
References: <1447408811.23126.110.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1447408811.23126.110.camel@haakon3.risingtidesystems.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Joel Becker <jlbec@evilplan.org>, Linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrzej Pietrasiewicz <andrzej.p@samsung.com>, Felipe Balbi <balbi@ti.com>
List-Id: linux-scsi@vger.kernel.org

What the hell is wrong with linux-scsi.org?

Your machine:
   Date: Fri, 13 Nov 2015 02:00:11 -0800

linux-iscsi.org:
    Received: from [192.168.1.69] ...
         by linux-iscsi.org (Postfix) with ESMTPSA id 80B6822DA37;
         Fri, 13 Nov 2015 09:55:48 +0000 (UTC)

mx.google.com:
  Received: from linux-iscsi.org ...
        Fri, 13 Nov 2015 02:00:23 -0800 (PST)

That stupid server clock is off by over four *minutes*. Notice the
jump back from just after the hour, to almost five minutes before the
hour?

Please get it some maintenance love. I'm OCD when it comes to
timekeeping, and something on the internet being off by four minutes
just makes me go "Eww".

ntp was invented, what, 35 years ago?

                     Linus
