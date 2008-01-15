From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [RFC] A SCSI fault injection framework using
	SystemTap.
Date: Mon, 14 Jan 2008 20:31:46 -0700
Message-ID: <20080115033145.GR18741@parisc-linux.org>
References: <478C22A9.5000009@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <478C22A9.5000009@ce.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "K.Tanaka" <k-tanaka@ce.jp.nec.com>
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Jan 15, 2008 at 12:04:09PM +0900, K.Tanaka wrote:
> I would like to introduce a SCSI fault injection framework using SystemTap.
> 
> Currently, kernel has Fault-injection framework and Faulty mode for md,
> which can also be used for testing the error handling. But, they could
> only produce fixed type of errors stochastically. In order to simulate
> more realistic scsi disk faults, I have created a  new flexible fault injection
> framework using SystemTap.

How does it compare to using scsi_debug, which I believe can do all of
the above and more?

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
