From: Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: Deadlock due to device removal - race condition in scsi/block layer?
Date: Mon, 31 Oct 2011 17:45:01 +0100
Message-ID: <CAO+b5-q0Mbfeb-57UsGYzjz0S=Z_Lra7o=HbpFxz83jHrvcnJA@mail.gmail.com>
References: <F9300DCD-387B-481A-85B2-5ED30204CADC@tuxera.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <F9300DCD-387B-481A-85B2-5ED30204CADC@tuxera.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Anton Altaparmakov <anton@tuxera.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 10/31/11, Anton Altaparmakov <anton@tuxera.com> wrote:
> We have seen a deadlock when doing "unplug whilst writing" testing.

Does this patch help: http://marc.info/?l=linux-scsi&m=131680195721932 ?

Bart.
