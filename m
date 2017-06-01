From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] target: Avoid target_shutdown_sessions loop during
 queue_depth change
Date: Thu, 01 Jun 2017 00:04:39 -0700
Message-ID: <1496300679.27407.207.camel@haakon3.risingtidesystems.com>
References: <1496300046-21234-1-git-send-email-nab@linux-iscsi.org>
         <20170601065715.GA17147@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20170601065715.GA17147@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Mike Christie <mchristi@redhat.com>, Hannes Reinecke <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2017-06-01 at 08:57 +0200, Christoph Hellwig wrote:
> How about this slightly easier to read version?

Fine by me.

Applied.
