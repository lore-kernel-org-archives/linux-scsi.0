From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: Deadlock observed in SCSI device removal
Date: Sat, 15 Dec 2012 10:04:23 +0100
Message-ID: <50CC3D17.10902@acm.org>
References: <CADDb1s0wdZfHTZ8jyKdT4zpsYg4+hYXCSBN5=bY3Q=03wBJT4Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CADDb1s0wdZfHTZ8jyKdT4zpsYg4+hYXCSBN5=bY3Q=03wBJT4Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Amit Sahrawat <amit.sahrawat83@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 12/15/12 05:22, Amit Sahrawat wrote:
> We are using kernel version 3.0.33, and the patch which is mentioned for
> the above problem - is already applied in the kernel.

If the kernel reports that io_schedule() hangs that usually means that 
an I/O request was not finished properly. It would help if you could 
verify whether or not you can reproduce this issue with kernel 3.6.10.

Bart.
