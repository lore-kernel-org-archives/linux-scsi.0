From: Stephen Cameron <stephenmcameron@gmail.com>
Subject: Re: [PATCH] hpsa: fix physical device lun and target numbering problem
Date: Tue, 9 Aug 2011 14:58:05 -0500
Message-ID: <CADzpL0TZfdQqoE-X-tN0SrsNSOvqJAsX8DzC46XpM_JihJY29w@mail.gmail.com>
References: <20110809131801.10649.44268.stgit@beardog.cce.hp.com>
	<CADzpL0SnZ+t6RT5iU2Ne+HEdBO1n2K51WwqaVDHXPs1CDHGk2A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CADzpL0SnZ+t6RT5iU2Ne+HEdBO1n2K51WwqaVDHXPs1CDHGk2A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, mikem@beardog.cce.hp.com, thenzl@redhat.com, akpm@linux-foundation.org, axboe@kernel.dk
List-Id: linux-scsi@vger.kernel.org

On Tue, Aug 9, 2011 at 8:33 AM, Stephen Cameron
<stephenmcameron@gmail.com> wrote:

> Despite the above patch, which I do think is correct, I can still get
> a panic (on RHEL 6.1 with 2.6.31-rc1 kernel)

Er, I meant 3.1-rc1, not 2.6.31-rc1.

-- steve
