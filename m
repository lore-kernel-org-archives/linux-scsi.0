From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: Yet another hot unplug NULL pointer dereference (was Re: status
 of oops in sd_revalidate_disk?)
Date: Fri, 16 Mar 2012 18:53:58 +0000
Message-ID: <4F638C46.30607@acm.org>
References: <4EE8E419.8010000@pre-sense.de> <CA+v9cxZFUC45WD0=+8mvH2Tq_xvX3PgaW4ttzPep0jqvqab_6w@mail.gmail.com> <20111225215804.03ef9402@stein> <4F3A46DD.8030305@ce.jp.nec.com> <4F5F8D82.2040704@acm.org> <4F6300BB.9060503@ce.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4F6300BB.9060503@ce.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, jbottomley@parallels.com, linux-scsi@vger.kernel.org, Huajun Li <huajun.li.lee@gmail.com>, Axel Theilmann <theilmann@pre-sense.de>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 03/16/12 08:58, Jun'ichi Nomura wrote:
> So, while there might be another race between sd_probe_async
> and scsi_host_remove, I believe your "[PATCH] Fix device
> removal NULL pointer dereference" still makes sense.

You are right, I have been too harsh for my own patch. I'll resend it.

Bart.
