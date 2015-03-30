From: Andy Grover <agrover@redhat.com>
Subject: Re: [RFC 00/22] target: se_node_acl LUN list RCU conversion
Date: Mon, 30 Mar 2015 12:35:55 -0700
Message-ID: <5519A59B.7060903@redhat.com>
References: <1427443512-8925-1-git-send-email-nab@daterainc.com> <20150330120823.GA20193@infradead.org> <5519A0F4.4020102@redhat.com> <20150330192130.GA27541@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20150330192130.GA27541@infradead.org>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagig@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

On 03/30/2015 12:21 PM, Christoph Hellwig wrote:
> On Mon, Mar 30, 2015 at 12:16:04PM -0700, Andy Grover wrote:
>> I dug my patches up and rebased on top of target-pending/for-next. Pushed
>> here:
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/grover/linux.git
>> mar30-dynalloc-deve
>>
>> https://git.kernel.org/cgit/linux/kernel/git/grover/linux.git/log/?h=mar30-dynalloc-deve
>>
>> if this is helpful for your efforts.
>
> See the branch above, it does everything your old series did except
> for dynamic allocation of the LUNs, although it gets there through a
> different way.
>

And you got rid of the redundant LUNFLAGS_READ_WRITE flag too, nice.

So what's next? Were you going to do the LUNs too? In addition to +perf 
and less mem usage, going down this path also leads to >256 LUNs per tpg.

Woot! -- Andy
