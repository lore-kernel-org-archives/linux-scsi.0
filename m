From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 0/3] Use sbitmap instead of percpu_ida
Date: Tue, 12 Jun 2018 14:40:43 -0600
Message-ID: <f7a9f7ad-843f-58fc-68f0-79dfd4019c18@kernel.dk>
References: <20180612190545.10781-1-willy@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <20180612190545.10781-1-willy@infradead.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Matthew Wilcox <willy@infradead.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux1394-devel@lists.sourceforge.net, linux-usb@vger.kernel.org, kvm@vger.kernel.org, virtualization@lists.linux-foundation.org, netdev@vger.kernel.org, Juergen Gross <jgross@suse.com>, qla2xxx-upstream@qlogic.com, Kent Overstreet <kent.overstreet@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On 6/12/18 1:05 PM, Matthew Wilcox wrote:
> Removing the percpu_ida code nets over 400 lines of removal.  It's not
> as spectacular as deleting an entire architecture, but it's still a
> worthy reduction in lines of code.
> 
> Untested due to lack of hardware and not understanding how to set up a
> target platform.
> 
> Changes from v1:
>  - Fixed bugs pointed out by Jens in iscsit_wait_for_tag()
>  - Abstracted out tag freeing as requested by Bart
>  - Made iscsit_wait_for_tag static as pointed out by 0day

Reviewed-by: Jens Axboe <axboe@kernel.dk>

-- 
Jens Axboe
