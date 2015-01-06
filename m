From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/2] ahci_xgene: Fix the dma state machine lockup for the
 ATA_CMD_PACKET PIO mode command.
Date: Tue, 6 Jan 2015 07:46:46 -0500
Message-ID: <20150106124646.GA3077@htj.dyndns.org>
References: <1418748575-27301-1-git-send-email-stripathi@apm.com>
 <1418748575-27301-3-git-send-email-stripathi@apm.com>
 <20150105135910.GD15833@htj.dyndns.org>
 <CAOHikRDXvN2guikwBr8E+pdRsm9UKeqMCA7LStGCxOMWRvHdBg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <CAOHikRDXvN2guikwBr8E+pdRsm9UKeqMCA7LStGCxOMWRvHdBg@mail.gmail.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Suman Tripathi <stripathi@apm.com>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Linux SCSI List <linux-scsi@vger.kernel.org>, Jon Masters <jcm@redhat.com>, patches@apm.com, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Don Dutile <ddutile@redhat.com>, Olof Johansson <olof@lixom.net>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Jan 06, 2015 at 01:51:15PM +0530, Suman Tripathi wrote:
> Hi
> 
> On Tue, Dec 16, 2014 at 10:19:35PM +0530, Suman Tripathi wrote:
> > This patch addresses the issue with ATA_CMD_PACKET pio mode
> > command for enumeration and device detection with ATAPI devices.It is the
> > same issue as in patch
> >
> > www.spinics.net/lists/linux-ide/msg49092.html
> >
> > Signed-off-by: Suman Tripathi <stripathi@apm.com>
> 
> Applied 1-2 to libata/for-3.18-fixes w/ Sergei's suggested edits.
> 
> The patch is applied to libata/for-3.19-fixes not libata/for-3.18-fixes ??

Yeap, brainfart.  libata/for-3.19-fixes is the right one.

Thanks.

-- 
tejun
