From: Jens Axboe <axboe@kernel.dk>
Subject: Re: remove the cmd_type field from struct request
Date: Tue, 31 Jan 2017 10:02:50 -0800
Message-ID: <bbe16fc1-5652-bbc2-03a5-0298c3f16645@kernel.dk>
References: <1485878251-6107-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1485878251-6107-1-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 01/31/2017 07:57 AM, Christoph Hellwig wrote:
> [1] which were a pain in the ass to untangle and debug during development,
> it's really time for it to die..

Outside of the patch series in question, how to we expedite the
euthanasia of IDE? What explicit features/support are we missing through
libata that would need to be added, before we can git rm drivers/ide/ ?

-- 
Jens Axboe
