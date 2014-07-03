From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] [SCSI] hpsa: fix non-x86 builds
Date: Thu, 3 Jul 2014 01:43:48 -0700
Message-ID: <20140703084348.GA16881@infradead.org>
References: <6003317.KPlAy1USkq@wuerfel>
 <20140626143445.GO25166@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20140626143445.GO25166@beardog.cce.hp.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: scameron@beardog.cce.hp.com
Cc: linux-arm-kernel@lists.infradead.org, jbottomley@parallels.com, linux-scsi@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Jun 26, 2014 at 09:34:45AM -0500, scameron@beardog.cce.hp.com wrote:
> Thanks.

Do you plan to include this with the next hpsa update, or should I take
this as an ACK and apply it?
