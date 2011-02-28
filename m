From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 0/5] target updates for scsi-post-merge .39 (round one)
Date: Mon, 28 Feb 2011 12:39:02 +0100
Message-ID: <AANLkTimDu-KFFfvWd95URQJMt2YbWU9tLwzNeE2Lf4OW@mail.gmail.com>
References: <1298874020-15628-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1298874020-15628-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-iscsi-target-dev@googlegroups.com
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Joel Becker <jlbec@evilplan.org>, Douglas Gilbert <dgilbert@interlog.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Feb 28, 2011 at 7:20 AM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
> Patches #1 -> #4 involve the addition of new ConfigFS context based
> statistics groups in target_core_stat.c following RFC-4455 to address
> the removal of the legacy ProcFS based target_core_mib.c in .38 code.

Hot-pluggable InfiniBand HCAs are available since some time. As I
wrote before, exporting RFC-4455 data via configfs instead of sysfs
makes implementing RFC 4455 in a (user space) SNMP agent overly
complex.

Bart.
