From: Mark Lord <kernel@teksavvy.com>
Subject: Re: Thin provisioning fixes
Date: Thu, 26 Nov 2009 10:14:30 -0500
Message-ID: <4B0E9B56.3040904@teksavvy.com>
References: <1258771524-26673-1-git-send-email-martin.petersen@oracle.com> <20091126105947.GA28120@infradead.org> <20091126110157.GV8742@kernel.dk> <20091126110545.GA364@infradead.org> <4B0E9B08.3020204@teksavvy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4B0E9B08.3020204@teksavvy.com>
Sender: linux-ide-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, james.bottomley@hansenpartnership.com, willy@wil.cx, jgarzik@pobox.com, sandeen@redhat.com, rwheeler@redhat.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Mark Lord wrote:
> Christoph Hellwig wrote:
>>
>> Note that we might have to add blacklists for this in libata pretty soon
>> as the OCZ Vertex seems to get it wrong, but that's material for another
>> patch not touching the block layer..
> ..
> 
> With the current (latest) firmware on the Vertex,
> it does not claim "read zeros after trim".
> Which is correct.
> 
> How does this get something wrong?
..

Oh.. answering my own question here..

All of the earlier firmwares *did* get it wrong,
so I suppose those could/should be X-listed.

Cheers!
