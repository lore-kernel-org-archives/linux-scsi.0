From: Fengguang Wu <wfg@linux.intel.com>
Subject: Re: =?utf-8?Q?drivers=2Fblock=2Fcpqarray?=
	=?utf-8?Q?=2Ec=3A938=3A2=3A_error=3A_too_many_arguments_to_function_?=
	=?utf-8?B?5oW0bGtfcnFfbWFwX3Nn77+9?=
Date: Thu, 14 Jun 2012 17:01:51 +0800
Message-ID: <20120614090151.GA12013@localhost>
References: <4fd91c3f.KAwMcygw9fFGn9Cx%wfg@linux.intel.com>
	<4FD984F3.3070502@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <4FD984F3.3070502@kernel.dk>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org, virtualization@lists.linux-foundation.org
List-Id: linux-scsi@vger.kernel.org

Hi Jens,

On Thu, Jun 14, 2012 at 08:30:11AM +0200, Jens Axboe wrote:
> On 06/14/2012 01:03 AM, wfg@linux.intel.com wrote:
> > FYI, kernel build failed on
> > 
> > tree:   git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git multiqueue
> > head:   e9a6aa8a0b7b93195774a9fcf551632bf3abcd97
> > commit: 67db7275fa4325d46853a4bfcb79acf32e48eca8 [1/3] multiqueue: a hodge podge of things
> 
> The multiqueue branch is a private branch, it's known broken on many
> configs at the moment.

OK. Sorry my script just blindly build tests every new/updated branches
in the tree. It does try to reduce noise level by remembering all warned
error messages. However if it still presents a problem to the private
branches, I can either explicitly blacklist "multiqueue", or let the
script automatically skip commits whose "^Signed-off-by:" is still missing.

Thanks,
Fengguang
